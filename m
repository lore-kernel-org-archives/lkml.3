Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3IIFTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:19:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40629 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3IIFTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:19:50 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-c6-522d5a74e40b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Lidza Louina'" <lidza.louina@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cead1b$e3272a00$a9757e00$%han@samsung.com>
In-reply-to: <004301cead1b$e3272a00$a9757e00$%han@samsung.com>
Subject: [PATCH 3/3] staging: dgap: Remove casting the return value which is a
 void pointer
Date: Mon, 09 Sep 2013 14:19:48 +0900
Message-id: <004a01cead1c$34078280$9c168780$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6tG+MPdGOj+j+ZT3mKmVwvD3OitAAADD+w
Content-language: ko
x-cr-hashedpuzzle: BrAj HvFD H1LJ KUcF L0/S NGQU OILs PZyp g9n8 hjFR jX4Q kvVk
 k+B8 n3DI tJzo
 tfSC;4;ZwByAGUAZwBrAGgAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBkAHoAYQAuAGwAbwB1AGkAbgBhAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{4F497647-A269-438C-AAA2-98509C741CE6};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 09 Sep 2013 05:19:41
 GMT;WwBQAEEAVABDAEgAIAAzAC8AMwBdACAAcwB0AGEAZwBpAG4AZwA6ACAAZABnAGEAcAA6ACAAUgBlAG0AbwB2AGUAIABjAGEAcwB0AGkAbgBnACAAdABoAGUAIAByAGUAdAB1AHIAbgAgAHYAYQBsAHUAZQAgAHcAaABpAGMAaAAgAGkAcwAgAGEAIAB2AG8AaQBkACAAcABvAGkAbgB0AGUAcgA=
x-cr-puzzleid: {4F497647-A269-438C-AAA2-98509C741CE6}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t8zI92SKN0gg+P7lC2aF69ns7i88BKr
	Ree760wWl3fNYXNg8dg56y67x/65a9g9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK6Ot7T9L
	wUfFitv3b7A2MPZKdzFyckgImEi8O3yQFcIWk7hwbz1bFyMXh5DAMkaJeX8+s8EUHZ7+CaxI
	SGARo0TzdgWIol+MEscnT2MHSbAJqEl8+XIYzBYRMJXY+H4KI4jNLJAvsfbbWnaIZluJdZMW
	gsU5BewkLr58DbZAWCBW4sSdMywgNouAqsTrcyfA6nmB6t9397FC2IISPybfY4GYqSWxfudx
	JghbXmLzmrfMXYwcQIeqSzz6qwtxgpHEowtToUpEJPa9eMcIcrOEwA1Wif8/57BAPGYq8eZB
	MzuE/YhdYv0dXYgbBCS+TT7EAjFTVmLTAWaIEkmJgytusExglJqF5KJZSC6aheSiWUhWL2Bk
	WcUomlqQXFCclF5kolecmFtcmpeul5yfu4kREsUTdjDeO2B9iDEZaP1EZinR5HxgEsgriTc0
	NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6P5IXNhz4//
	3nT5OG1ZJFWjEZgjsOt6OHPMuT/JCoXTcyLc7FevXyD+68a8D5w6VwPcm4RVG/uXMyx64DnJ
	39TRtv5nj+Oak7ekq+emVbamBZR4nuWp6/3sVZ/gpfDU8YXDG66Aheor2t78a2jhOV67fvnh
	h1ayWpu/LhKwFYl69MjV5BXbciWW4oxEQy3mouJEAPYYqzL4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAd2SKN0gg57Z8hbNi9ezWVxeeInV
	ovPddSaLy7vmsDmweOycdZfdY//cNewefVtWMXp83iQXwBLVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYx5jR1vafpeCjYsXt+zdYGxh7pbsYOTkkBEwkDk//xAphi0lcuLee
	DcQWEljEKNG8XaGLkQvI/sUocXzyNHaQBJuAmsSXL4fBbBEBU4mN76cwgtjMAvkSa7+tZYdo
	tpVYN2khWJxTwE7i4svXYEOFBWIlTtw5wwJiswioSrw+dwKsnheo/n13HyuELSjxY/I9FoiZ
	WhLrdx5ngrDlJTavecvcxcgBdKi6xKO/uhAnGEk8ujAVqkREYt+Ld4wgN0sI3GCV+P9zDgvE
	Y6YSbx40s09gFJmFZMUsJCtmIVkxC8msBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC
	k8QzqR2MKxssDjEKcDAq8fBK/NcJEmJNLCuuzD3EKMHBrCTCe/45UIg3JbGyKrUoP76oNCe1
	+BBjMjAEJjJLiSbnAxNYXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2
	MHFwSjUw+u5S5tjHWeT8Ye3jS5k31glKJcvKcv3XOh0iF2ntMPeQhF79TNezUjPEy1mqPwp5
	uTJZHPOTeePw+5T6e9EC2WWKnlMrtqzufclZOiNHLnJu7JtC1RvyXEf+z83etiNW7dY3/WJv
	dk0m7TUpK3isvZ6bHwiUFLwdFDJn5eJ/N5pW31Fdd3mDEktxRqKhFnNRcSIA1jHos1YDAAA=
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
 drivers/staging/dgap/dgap_parse.c |    6 ++++--
 drivers/staging/dgap/dgap_sysfs.c |   22 +++++++++++-----------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/dgap/dgap_parse.c b/drivers/staging/dgap/dgap_parse.c
index 5497e6d..3bb79c5 100644
--- a/drivers/staging/dgap/dgap_parse.c
+++ b/drivers/staging/dgap/dgap_parse.c
@@ -1013,8 +1013,10 @@ static void dgap_err(char *s)
 static struct cnode *dgap_newnode(int t)
 {
 	struct cnode *n;
-	if ( (n = (struct cnode *) kmalloc(sizeof(struct cnode ), GFP_ATOMIC) ) != NULL) {
-		memset( (char *)n, 0, sizeof(struct cnode ) );
+
+	n = kmalloc(sizeof(struct cnode), GFP_ATOMIC);
+	if (n != NULL) {
+		memset((char *)n, 0, sizeof(struct cnode));
 		n->type = t;
 	}
 	return(n);
diff --git a/drivers/staging/dgap/dgap_sysfs.c b/drivers/staging/dgap/dgap_sysfs.c
index 94da06f..7f4ec9a 100644
--- a/drivers/staging/dgap/dgap_sysfs.c
+++ b/drivers/staging/dgap/dgap_sysfs.c
@@ -395,7 +395,7 @@ static ssize_t dgap_tty_state_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -420,7 +420,7 @@ static ssize_t dgap_tty_baud_show(struct device *d, struct device_attribute *att
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -445,7 +445,7 @@ static ssize_t dgap_tty_msignals_show(struct device *d, struct device_attribute
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -479,7 +479,7 @@ static ssize_t dgap_tty_iflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -504,7 +504,7 @@ static ssize_t dgap_tty_cflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -529,7 +529,7 @@ static ssize_t dgap_tty_oflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -554,7 +554,7 @@ static ssize_t dgap_tty_lflag_show(struct device *d, struct device_attribute *at
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -579,7 +579,7 @@ static ssize_t dgap_tty_digi_flag_show(struct device *d, struct device_attribute
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -604,7 +604,7 @@ static ssize_t dgap_tty_rxcount_show(struct device *d, struct device_attribute *
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -629,7 +629,7 @@ static ssize_t dgap_tty_txcount_show(struct device *d, struct device_attribute *
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
@@ -661,7 +661,7 @@ static ssize_t dgap_tty_name_show(struct device *d, struct device_attribute *att
 
 	if (!d)
 		return (0);
-	un = (struct un_t *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un || un->magic != DGAP_UNIT_MAGIC)
 		return (0);
 	ch = un->un_ch;
-- 
1.7.10.4


