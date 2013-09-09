Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3IIFOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:14:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44981 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3IIFOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:14:52 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-71-522d594a79a4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "'Daniel Borkmann'" <danborkmann@iogearbox.net>,
        "'Ariane Keller'" <ariane.keller@tik.ee.ethz.ch>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] char: xilinx_hwicap: Remove casting the return value which is
 a void pointer
Date: Mon, 09 Sep 2013 14:14:50 +0900
Message-id: <004101cead1b$825d7c10$87187430$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6tG3v4fLx5u4coQUu60gapHza1uw==
Content-language: ko
x-cr-hashedpuzzle: DyIi I+i2 Ju2Y X473 dKq9 fljJ gHE8 g/iP osP/ ovhv vdc/ xFi+
 1Igv 9hm4 +J58
 AB6Xww==;6;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGEAcgBpAGEAbgBlAC4AawBlAGwAbABlAHIAQAB0AGkAawAuAGUAZQAuAGUAdABoAHoALgBjAGgAOwBkAGEAbgBiAG8AcgBrAG0AYQBuAG4AQABpAG8AZwBlAGEAcgBiAG8AeAAuAG4AZQB0ADsAZwByAGUAZwBrAGgAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{829B2185-20A5-4790-8C33-261B72162AF0};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 09 Sep 2013 05:14:39
 GMT;WwBQAEEAVABDAEgAXQAgAGMAaABhAHIAOgAgAHgAaQBsAGkAbgB4AF8AaAB3AGkAYwBhAHAAOgAgAFIAZQBtAG8AdgBlACAAYwBhAHMAdABpAG4AZwAgAHQAaABlACAAcgBlAHQAdQByAG4AIAB2AGEAbAB1AGUAIAB3AGgAaQBjAGgAIABpAHMAIABhACAAdgBvAGkAZAAgAHAAbwBpAG4AdABlAHIA
x-cr-puzzleid: {829B2185-20A5-4790-8C33-261B72162AF0}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ12vSN0gg1Or5S3mrF/DZjFpwll2
	i541HYwWzYvXs1lcXniJ1eLyrjlsDmweXTcuMXucmPGbxWP/3DXsHn1bVjF6HPvwlc3j8ya5
	ALYoLpuU1JzMstQifbsEroyJG7pYC7awVXzY84q5gXEDaxcjB4eEgInEkxf8XYycQKaYxIV7
	69lAbCGBZYwS//bzQcRNJDoePWTpYuQCik9nlJj//jMzhPOLUWLpo0VgHWwCahJfvhxmBxkq
	IqAv0daiAVLDLHAHaNDmHrAaYYF4ic7eT+wgNouAqsShX1vAbF4BW4lT206wQtiCEj8m32MB
	sZkFtCTW7zzOBGHLS2xe85YZ4mh1iUd/dUHCIgJ6Eiv2XGKEKBGR2PfiHSPIXgmBH2wSJ881
	MEN8YCqx6P1iVojEV3aJM0umM0IcISDxbfIhFoihshKbDkDVS0ocXHGDZQKjxCwkJ81CctIs
	JCfNQrJ7ASPLKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQ6J24g/H+AetDjMlA6ycyS4km
	5wOjP68k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jDFfvTj01D7/CbnG+8xh1vH3OxXXPvzonK+nvsD27eyvvy9tu/KCY5uSgoyplddPx95PBp2p
	4qbzviXtmv9fgf1syKn+jtMJkyJzfnsl74+cJWYhl25vdbX85ekGhRPts85K1t1PZFz1+OjV
	iFe+G6VPBRXwHCq1PPK770aboOlsG+MVxWn/5iuxFGckGmoxFxUnAgB1onK29AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jQV2vSN0gg6ubpS3mrF/DZjFpwll2
	i541HYwWzYvXs1lcXniJ1eLyrjlsDmweXTcuMXucmPGbxWP/3DXsHn1bVjF6HPvwlc3j8ya5
	ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZEzd0sRZsYav4sOcVcwPj
	BtYuRk4OCQETiY5HD1kgbDGJC/fWs3UxcnEICUxnlJj//jMzhPOLUWLpo0VsIFVsAmoSX74c
	Zu9i5OAQEdCXaGvRAKlhFrjDKPFvcw9YjbBAvERn7yd2EJtFQFXi0K8tYDavgK3EqW0nWCFs
	QYkfk++BbWYW0JJYv/M4E4QtL7F5zVtmkPkSAuoSj/7qgoRFBPQkVuy5xAhRIiKx78U7RpC9
	EgI/2CROnmtghvjAVGLR+8WsExiFZiFZMQvJillIVsxCMmsBI8sqRtHUguSC4qT0XCO94sTc
	4tK8dL3k/NxNjOD08Ex6B+OqBotDjAIcjEo8vDcEdYOEWBPLiitzDzFKcDArifCef64TJMSb
	klhZlVqUH19UmpNafIgxGRgCE5mlRJPzgakrryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC
	6YklqdmpqQWpRTBbmDg4pRoYi5mOhjwoDnmfct/qxOzJEsv/HDl4bsFnpSJGDZ5zHMdZfK58
	FmVkssq0/DbrqY7Q+cye4gsnFNvMMg7x12bZHftqWydtJcPy7NnUl5rLKj4LzUuN9Y9KNp0Y
	5LM5upctuLpi90f9FIdzYSuPpbfq82mkhRWHbbnQr2fGzhN2NKFLc+e1kFAlluKMREMt5qLi
	RAB1n+QOUwMAAA==
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
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 5224da5..a7f65c2 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -721,7 +721,7 @@ static int hwicap_remove(struct device *dev)
 {
 	struct hwicap_drvdata *drvdata;
 
-	drvdata = (struct hwicap_drvdata *)dev_get_drvdata(dev);
+	drvdata = dev_get_drvdata(dev);
 
 	if (!drvdata)
 		return 0;
-- 
1.7.10.4


