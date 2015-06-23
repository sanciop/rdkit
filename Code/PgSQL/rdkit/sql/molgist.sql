CREATE INDEX molidx ON pgmol USING gist (m);

SET rdkit.tanimoto_threshold = 0.8;
SET rdkit.dice_threshold = 0.8;


SET enable_indexscan=off;
SET enable_bitmapscan=off;
SET enable_seqscan=on;

SELECT count(*) FROM pgmol WHERE m @> 'c1ccccc1';
SELECT count(*) FROM pgmol WHERE m @> 'c1cccnc1';
SELECT count(*) FROM pgmol WHERE 'c1ccccc1' <@ m;
SELECT count(*) FROM pgmol WHERE 'c1cccnc1' <@ m;
SELECT count(*) FROM pgmol WHERE m @> 'c1ccccc1C(=O)N';

SET enable_indexscan=on;
SET enable_bitmapscan=on;
SET enable_seqscan=off;

SELECT count(*) FROM pgmol WHERE m @> 'c1ccccc1';
SELECT count(*) FROM pgmol WHERE m @> 'c1cccnc1';
SELECT count(*) FROM pgmol WHERE 'c1ccccc1' <@ m;
SELECT count(*) FROM pgmol WHERE 'c1cccnc1' <@ m;
SELECT count(*) FROM pgmol WHERE m @> 'c1ccccc1C(=O)N';

SET enable_indexscan=on;
SET enable_bitmapscan=on;
SET enable_seqscan=on;

DROP INDEX molidx;

-- ###############################
-- github issue #525
CREATE TABLE chemblmol (molregno int, m mol);
\copy chemblmol from 'data/chembl20_100.csv' (format csv)
CREATE INDEX mol_idx2 ON chemblmol using gist(m);

-- start with a direct seq scan to verify that there is a result
SET enable_indexscan=off;
SET enable_bitmapscan=off;
SET enable_seqscan=on;
select count(*) from chemblmol where m@='Cc1cc(-n2ncc(=O)[nH]c2=O)ccc1C(=O)c1ccccc1Cl'::mol;

-- now enable the index to trigger the bug:
SET enable_indexscan=on;
SET enable_bitmapscan=off;
SET enable_seqscan=on;
select count(*) from chemblmol where m@='Cc1cc(-n2ncc(=O)[nH]c2=O)ccc1C(=O)c1ccccc1Cl'::mol;



