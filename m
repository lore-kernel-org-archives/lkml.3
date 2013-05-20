Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3ETXzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:55:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48245 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab3ETXzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:55:53 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-f1-519ab806a31d
Date: Mon, 20 May 2013 23:55:50 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] i2c: i2c-designware: Fix compilation warning
To: wsa@the-dreams.de, linux-i2c@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130520234352411@eunb.song
Msgkey: 20130520234352411@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130520234352411@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2512686.216921369094149829.JavaMail.weblogic@epml25>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zji7bjlmBBu8eW1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6ML8e2shX84ao4svsjUwPjFa4uRk4OIQEViZb/3xlBbAkBE4mr
	y1ZC2WISF+6tZ+ti5AKqWcYoceXCArii7W3/mCAS8xklvj5fwASSYBFQlZhw9y4LiM0moC3x
	9ssDVhBbWMBWYnrzVjBbRMBGomnCLmYQm1nAUeLR5TvMEFfIS0w+fZkdxOYVEJQ4OfMJ0BwO
	oGVKEgvvaYKYvALKEi1zNSFOkJCYNf0CK4TNKzGj/SkLhC0nMe3rGmYIW1ri/KwNcL8s/v4Y
	Ks4vcez2DiaI6bwST+4Hw4zZvfkLG4QtIDH1zEGoVnWJ9XP+QLXySaxZ+JYFZsyuU8uZYXrv
	b5nLBPGUosSU7ofsELaWxJcf+9hQPQViO0pc2D6feQKj8iwkqVlI2mchaUdWs4CRZRWjaGpB
	ckFxUnqRiV5xYm5xaV66XnJ+7iZGSFKYsIPx3gHrQ4zJwAiZyCwlmpwPTCp5JfGGxmZGFqYm
	psZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDkS10ZP2tN3t6A9Wtn
	SvXyXnG6fHjGas15v183aHAcdNSt0Xzfv+LA1mi1ST+cf2Ymu3oJTJSbx7BwxacZi2wSdrbc
	nqf18W69o4bboscFK/NEWv8bZuaYJ0/R5z211rlsmexfK/7iCT2C37IYzzTuWRloP11z7zKn
	rsTdHSeVvuX/6O7p6uhQYinOSDTUYi4qTgQA7WNncCADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2TF22HbMCDZa3WVpc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jC/HtrIV/OGqOLL7I1MD4xWuLkZODiEBFYmW/98ZQWwJAROJ7W3/mCBsMYkL99azdTFyAdXM
	Z5T4+nwBWIJFQFViwt27LCA2m4C2xNsvD1hBbGEBW4npzVvBbBEBG4mmCbuYQWxmAUeJR5fv
	MEMsk5eYfPoyO4jNKyAocXLmE6A5HEDLlCQW3tMEMXkFlCVa5mpCnCAhMWv6BVYIm1diRvtT
	FghbTmLa1zXMELa0xPlZGxhhTl78/TFUnF/i2O0dTBDTeSWe3A+GGbN78xc2CFtAYuqZg1Ct
	6hLr5/yBauWTWLPwLQvMmF2nljPD9N7fMpcJ4ilFiSndD9khbC2JLz/2saF6CsR2lLiwfT7z
	BEa5WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9ApDveLE3OLSvHS95PzcTYzg9PRs4Q7GL+et
	DzEKcDAq8fAKGM4KFGJNLCuuzD3EKMHBrCTC+70ZKMSbklhZlVqUH19UmpNafIgxGRh9E5ml
	RJPzgakzryTe0NjA2NDQ0tzA1NDIgjRhJXHep63WgUIC6YklqdmpqQWpRTBbmDg4pRoY3XX/
	FogdE7HcVrDgaPX5zaVyX9isTvCHeDWeSp1p9H6WRMO7O0r80sscJ5Rz8v48Jzq9a3N52/VZ
	xZzB0txhc0v10ptbeyvSxKbL3JNhuuH9YdH5XX3LHx+TOJG1asE20aIGBre9TCnL9Nr4LFea
	n08zCu8q0/3nbevDZHObfX9DT1BFqr8SS3FGoqEWc1FxIgDg8MQWkwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4KNu1LI016689


Fix the following compilation warning when CONFIG_PM_RUNTIME is not enabled:

drivers/i2c/busses/i2c-designware-pcidrv.c:188: warning: 'i2c_dw_pci_runtime_idle' defined but not used

Signed-off-by: EunBong Song <eunb.song@samsung.com>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index f6ed06c..2b5d3a6 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -185,6 +185,7 @@ static int i2c_dw_pci_resume(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
 static int i2c_dw_pci_runtime_idle(struct device *dev)
 {
 	int err = pm_schedule_suspend(dev, 500);
@@ -194,6 +195,7 @@ static int i2c_dw_pci_runtime_idle(struct device *dev)
 		return 0;
 	return -EBUSY;
 }
+#endif
 
 static const struct dev_pm_ops i2c_dw_pm_ops = {
 	.resume         = i2c_dw_pci_resume,
-- 
1.7.10.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
