Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab3K0ORI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:17:08 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17927 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3K0OQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:16:53 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-92-5295fed35233
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] mfd: max14577: Match regulator by of_compatible string
Date: Wed, 27 Nov 2013 15:16:17 +0100
Message-id: <1385561777-20499-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCJMWRmVeSWpSXmKPExsVy+t/xK7qX/00NMpi6ncNi44z1rBavXxha
	nG16w25x/+tRRovLu+awWaw9cpfd4nQ3qwO7x51re9g85p0M9OjbsorR4/MmuQCWKC6blNSc
	zLLUIn27BK6Mj5N+MxYsZa3YdbKDpYFxJUsXIweHhICJREN/SBcjJ5ApJnHh3no2EFtIYCmj
	xO2V+V2MXEB2H5PErYsd7CAJNgFjic3Ll4AViQhkSfyYtpoFpIhZ4CijxI1Zd5lAEsIC7hLT
	l04Ha2ARUJVY2fmDGcTmBYpfetXIDLFYQWLOJJsJjNwLGBlWMYqmliYXFCel5xrpFSfmFpfm
	pesl5+duYoSExNcdjEuPWR1iFOBgVOLhdb4xJUiINbGsuDL3EKMEB7OSCG/myalBQrwpiZVV
	qUX58UWlOanFhxiZODilGhiVe2KVKi5ax2lt/M3mJDBFcjlbCNs1/qecSr91zA5sMdLJl39T
	nuwxYd9lgyBptsJrkfuTWZYIxe1Y1WPddXnr4ozUsCVHJ2aFb/h8x3lrWs3a9a1LNXM3ff/Y
	uIFhyf+k7rnJxY8tppkLdMx4rpDuaTJHK+iP/IQnPitOL2gPlE67xcToU6TEUpyRaKjFXFSc
	CACplJn85wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Match max14577 regulator driver by of_compatible specified in mfd_cell.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max14577.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 94b766d..1337c45 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -26,7 +26,10 @@
 
 static struct mfd_cell max14577_devs[] = {
 	{ .name = "max14577-muic", },
-	{ .name = "max14577-regulator", },
+	{
+		.name = "max14577-regulator",
+		.of_compatible = "maxim,max14577-regulator",
+	},
 	{ .name = "max14577-charger", },
 };
 
-- 
1.7.9.5

