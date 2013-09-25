Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab3IYXf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:35:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10508 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3IYXf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:35:57 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-ce-52437356ad84
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Lidza Louina'" <lidza.louina@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2] staging: dgnc: Remove casting the return value which is a
 void pointer
Date: Thu, 26 Sep 2013 08:35:49 +0900
Message-id: <000a01ceba47$f799a8d0$e6ccfa70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66R/L1fPs8smyfQGu0EzOA9CipXQ==
Content-language: ko
x-cr-hashedpuzzle: BX2U NXRq THSd Vbw5 V7yj aMQG c1s6 fQnZ fYqg m9Gw n+1j oyxT
 qWW7 s7uV v5tc
 xxtn;4;ZwByAGUAZwBrAGgAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBkAHoAYQAuAGwAbwB1AGkAbgBhAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{98AFBA2F-3109-40AB-87D7-E61FCDE1991A};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 25 Sep 2013 23:35:42
 GMT;WwBQAEEAVABDAEgAIABWADIAXQAgAHMAdABhAGcAaQBuAGcAOgAgAGQAZwBuAGMAOgAgAFIAZQBtAG8AdgBlACAAYwBhAHMAdABpAG4AZwAgAHQAaABlACAAcgBlAHQAdQByAG4AIAB2AGEAbAB1AGUAIAB3AGgAaQBjAGgAIABpAHMAIABhACAAdgBvAGkAZAAgAHAAbwBpAG4AdABlAHIA
x-cr-puzzleid: {98AFBA2F-3109-40AB-87D7-E61FCDE1991A}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zA92wYucgg29NPBbNi9ezWVxeeInV
	ovPddSaLy7vmsDmweOycdZfdY//cNewefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlfHsMlvB
	aZWKbTt+sTQwrpbtYuTkkBAwkdgzZRMzhC0mceHeerYuRi4OIYFljBLPmv4wwRRNfjOBESIx
	nVHi1rkn7BDOL0aJDc3NrCBVbAJqEl++HGYHsUUETCU2vp/CCGIzC+RLrP22FiwuLBAjseX9
	EbB1LAKqEk93TWYDsXkFbCX2NL5khrAFJX5MvscC0aslsX7ncSYIW15i85q3QDUcQBepSzz6
	qwuxSk/iRccyVogSEYl9L96BHSohcIVV4tSlz6wQH5hKnP14iAUicY5dYu3CnSwQRwhIfJsM
	kgAZKiux6QA0KCQlDq64wTKBUWIWkpNmITlpFpKTZiHZvYCRZRWjaGpBckFxUnqRiV5xYm5x
	aV66XnJ+7iZGSFxO2MF474D1IcZkoPUTmaVEk/OBcZ1XEm9obGZkYWpiamxkbmlGmrCSOK96
	i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbSHz80dboT2uVL+6r1V50SeBAwtY/3QduN
	NUI+H7YePqrQkVci8NNkZvImx1k2SV94l4acT/gbsnOOwSzNfWJp848cj4pya9mZGaH1U9+8
	TVagTni/p/rXeeG9WfE1WUJXb9b+KRVstVJoiLzQOP3m5V0Sb+Q2L9ssm1tU3rVi/9foilVe
	HUosxRmJhlrMRcWJACqkFQLhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQd2wYucggxOn2C2aF69ns7i88BKr
	Ree760wWl3fNYXNg8dg56y67x/65a9g9+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwjjHj2WW2gtMqFdt2/GJpYFwt28XIySEhYCIx+c0ERghbTOLCvfVs
	XYxcHEIC0xklbp17wg7h/GKU2NDczApSxSagJvHly2F2EFtEwFRi4/spYN3MAvkSa7+tBYsL
	C8RIbHl/hBnEZhFQlXi6azIbiM0rYCuxp/ElM4QtKPFj8j0WiF4tifU7jzNB2PISm9e8Barh
	ALpIXeLRX12IVXoSLzqWsUKUiEjse/GOEeQ2CYErrBKnLn1mhfjAVOLsx0MsExiFZiFZMQvJ
	illIVsxCMmsBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCofya1g3Flg8UhRgEORiUe
	3gvMzkFCrIllxZW5hxglOJiVRHi/GQGFeFMSK6tSi/Lji0pzUosPMSYDQ2Ais5Rocj4wIeWV
	xBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+PhmNSPC94qWb+a
	kvBz1yPHTwKnfDY+37MwLSCpStF6xdctJ3v6HxrESPaUCp0O+Xh0+hf/aLZWjltrK+4s/n3v
	hbu7/v5P9TV77By59B8f+H74vOj1gHMXhTU3Cd68/k7s4qmv/cd2bD12/OUWuZ7t1p+u3Hwn
	9mYBw5GdslotfzwKr8cw3bxyQImlOCPRUIu5qDgRAHG7WZw+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting the return value which is a void pointer is redundant.
The conversion from void pointer to any other pointer type is
guaranteed by the C programming language.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Rebased on the latest linux-next

 drivers/staging/dgnc/dgnc_driver.c |    4 ++--
 drivers/staging/dgnc/dgnc_sysfs.c  |   22 +++++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index 1318a70..b125fa3 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -499,7 +499,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 
 	/* get the board structure and prep it */
 	brd = dgnc_Board[dgnc_NumBoards] =
-	(struct dgnc_board *) kzalloc(sizeof(struct dgnc_board), GFP_KERNEL);
+		kzalloc(sizeof(struct dgnc_board), GFP_KERNEL);
 	if (!brd) {
 		APR(("memory allocation for board structure failed\n"));
 		return -ENOMEM;
@@ -507,7 +507,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 
 	/* make a temporary message buffer for the boot messages */
 	brd->msgbuf = brd->msgbuf_head =
-		(char *) kzalloc(sizeof(char) * 8192, GFP_KERNEL);
+		kzalloc(sizeof(char) * 8192, GFP_KERNEL);
 	if (!brd->msgbuf) {
 		kfree(brd);
 		APR(("memory allocation for board msgbuf failed\n"));
diff --git a/drivers/staging/dgnc/dgnc_sysfs.c b/drivers/staging/dgnc/dgnc_sysfs.c
index 5834e0c..946230c 100644
--- a/drivers/staging/dgnc/dgnc_sysfs.c
+++ b/drivers/staging/dgnc/dgnc_sysfs.c
@@ -433,7 +433,7 @@ static ssize_t dgnc_tty_state_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
@@ -458,7 +458,7 @@ static ssize_t dgnc_tty_baud_show(struct device *d, struct device_attribute *att
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
@@ -483,7 +483,7 @@ static ssize_t dgnc_tty_msignals_show(struct device *d, struct device_attribute
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
@@ -517,7 +517,7 @@ static ssize_t dgnc_tty_iflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
@@ -542,7 +542,7 @@ static ssize_t dgnc_tty_cflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
@@ -567,7 +567,7 @@ static ssize_t dgnc_tty_oflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
@@ -592,7 +592,7 @@ static ssize_t dgnc_tty_lflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
@@ -617,7 +617,7 @@ static ssize_t dgnc_tty_digi_flag_show(struct device *d, struct device_attribute
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
@@ -642,7 +642,7 @@ static ssize_t dgnc_tty_rxcount_show(struct device *d, struct device_attribute *
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
@@ -667,7 +667,7 @@ static ssize_t dgnc_tty_txcount_show(struct device *d, struct device_attribute *
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
@@ -692,7 +692,7 @@ static ssize_t dgnc_tty_name_show(struct device *d, struct device_attribute *att
 
 	if (!d)
 		return 0;
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return 0;
 	ch = un->un_ch;
-- 
1.7.10.4


