Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3IIFS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:18:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39825 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3IIFS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:18:57 -0400
X-AuditID: cbfee68e-b7f756d000004512-c8-522d5a40867b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Lidza Louina'" <lidza.louina@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cead1b$e3272a00$a9757e00$%han@samsung.com>
In-reply-to: <004301cead1b$e3272a00$a9757e00$%han@samsung.com>
Subject: [PATCH 2/3] staging: dgnc: Remove casting the return value which is a
 void pointer
Date: Mon, 09 Sep 2013 14:18:55 +0900
Message-id: <004901cead1c$14c97680$3e5c6380$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6tG+MPdGOj+j+ZT3mKmVwvD3OitAAAA3WA
Content-language: ko
x-cr-hashedpuzzle: ATwx B3w/ CWUr C8Yc E7sa H29R I8hv KFi0 QB49 RIhr R4FE WxX3
 YUjp Yfgl ZFj9
 bHR2;4;ZwByAGUAZwBrAGgAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBkAHoAYQAuAGwAbwB1AGkAbgBhAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{003FF6CF-A24C-4847-870B-87DB6C4CDA52};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 09 Sep 2013 05:18:51
 GMT;WwBQAEEAVABDAEgAIAAyAC8AMwBdACAAcwB0AGEAZwBpAG4AZwA6ACAAZABnAG4AYwA6ACAAUgBlAG0AbwB2AGUAIABjAGEAcwB0AGkAbgBnACAAdABoAGUAIAByAGUAdAB1AHIAbgAgAHYAYQBsAHUAZQAgAHcAaABpAGMAaAAgAGkAcwAgAGEAIAB2AG8AaQBkACAAcABvAGkAbgB0AGUAcgA=
x-cr-puzzleid: {003FF6CF-A24C-4847-870B-87DB6C4CDA52}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zQ12HKN0gg5dTFC2aF69ns7i88BKr
	Ree760wWl3fNYXNg8dg56y67x/65a9g9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2Pyyx6W
	gtMqFc+2b2JuYNwi28XIySEhYCLx8+l2JghbTOLCvfVsXYxcHEICyxglWrdcZYEpernuKTNE
	YjqjxPPbD8ESQgK/GCUmPuMDsdkE1CS+fDnMDmKLCJhKbHw/hRHEZhbIl1j7bS07RL2txLpJ
	C8HinAJ2EhdfvgbaxsEhLBArcW4RF0iYRUBVYveVNawgYV6g8lPPwDbxCghK/Jh8jwViopbE
	+p3HmSBseYnNa94yg5RLCKhLPPqrC3GAkcTuvmtQ5SIS+168YwS5XkLgBqvE+23dzBBvmUpM
	nbSZDSLxll1i//WTLBA3CEh8m3yIBWKorMSmA1D1khIHV9xgmcAoNQvJSbOQnDQLyUmzkOxe
	wMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkhvt2MN48YH2IMRlo/URmKdHkfGAKyCuJ
	NzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY9Ec0cKX
	V0Q4pRXWcglXeG+N9xNw+P/e6f2r63HR+QLPSw7pfYn6utHw9wJOuWPtYj9WbzA9stzs9ufo
	/sXvPcSmexZNiTmd4sHEu3z+DK/m0Miolf5+T8IVtBymnoyRPfv7dOL7lHVnum/e13kSMEf6
	9at7oQ0PVVmD2H9U3dt7Z/WyIzUe6UosxRmJhlrMRcWJAGLdpK/3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQV2HKN0gg2sXZSyaF69ns7i88BKr
	Ree760wWl3fNYXNg8dg56y67x/65a9g9+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwjjFj8sseloLTKhXPtm9ibmDcItvFyMkhIWAi8XLdU2YIW0ziwr31
	bF2MXBxCAtMZJZ7ffsgCkhAS+MUoMfEZH4jNJqAm8eXLYXYQW0TAVGLj+ymMIDazQL7E2m9r
	2SHqbSXWTVoIFucUsJO4+PI10FAODmGBWIlzi7hAwiwCqhK7r6xhBQnzApWfega2iVdAUOLH
	5HssEBO1JNbvPM4EYctLbF7zlhmkXEJAXeLRX12IA4wkdvddgyoXkdj34h0jyPUSAjdYJd5v
	64Z6y1Ri6qTNbBMYRWYhWTELyYpZSFbMQjJrASPLKkbR1ILkguKk9FwjveLE3OLSvHS95Pzc
	TYzgBPFMegfjqgaLQ4wCHIxKPLw3BHWDhFgTy4orcw8xSnAwK4nwnn+uEyTEm5JYWZValB9f
	VJqTWnyIMRkYABOZpUST84HJK68k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakF
	qUUwW5g4OKUaGA0M1j/pmxYheexX1I7AE68fvD9+kuv6sSXvJ1d3r93fH/gr+o7Jwxenf0We
	z5eMj9bbucdhoa2BaF2X0m1m7kfHqgzPd/HtUGK4MbP5bPyl7AvPljB+e/Mu3XolD88mmbUv
	hS7fP5b59yjj9lkLwyfUHW5u5njx/fnloNt+GxUvb92Q77vjPZe4EktxRqKhFnNRcSIAXkGv
	H1QDAAA=
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
 drivers/staging/dgnc/dgnc_driver.c |    4 ++--
 drivers/staging/dgnc/dgnc_sysfs.c  |   22 +++++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index f8c1e22..ba08af3 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -499,7 +499,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 
 	/* get the board structure and prep it */
 	brd = dgnc_Board[dgnc_NumBoards] =
-	(struct board_t *) kzalloc(sizeof(struct board_t), GFP_KERNEL);
+		kzalloc(sizeof(struct board_t), GFP_KERNEL);
 	if (!brd) {
 		APR(("memory allocation for board structure failed\n"));
 		return(-ENOMEM);
@@ -507,7 +507,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 
 	/* make a temporary message buffer for the boot messages */
 	brd->msgbuf = brd->msgbuf_head =
-		(char *) kzalloc(sizeof(char) * 8192, GFP_KERNEL);
+		kzalloc(sizeof(char) * 8192, GFP_KERNEL);
 	if (!brd->msgbuf) {
 		kfree(brd);
 		APR(("memory allocation for board msgbuf failed\n"));
diff --git a/drivers/staging/dgnc/dgnc_sysfs.c b/drivers/staging/dgnc/dgnc_sysfs.c
index 0ea6c80..24d550e 100644
--- a/drivers/staging/dgnc/dgnc_sysfs.c
+++ b/drivers/staging/dgnc/dgnc_sysfs.c
@@ -433,7 +433,7 @@ static ssize_t dgnc_tty_state_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -458,7 +458,7 @@ static ssize_t dgnc_tty_baud_show(struct device *d, struct device_attribute *att
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -483,7 +483,7 @@ static ssize_t dgnc_tty_msignals_show(struct device *d, struct device_attribute
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -517,7 +517,7 @@ static ssize_t dgnc_tty_iflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -542,7 +542,7 @@ static ssize_t dgnc_tty_cflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -567,7 +567,7 @@ static ssize_t dgnc_tty_oflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -592,7 +592,7 @@ static ssize_t dgnc_tty_lflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -617,7 +617,7 @@ static ssize_t dgnc_tty_digi_flag_show(struct device *d, struct device_attribute
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -642,7 +642,7 @@ static ssize_t dgnc_tty_rxcount_show(struct device *d, struct device_attribute *
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -667,7 +667,7 @@ static ssize_t dgnc_tty_txcount_show(struct device *d, struct device_attribute *
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -692,7 +692,7 @@ static ssize_t dgnc_tty_name_show(struct device *d, struct device_attribute *att
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
-- 
1.7.10.4


