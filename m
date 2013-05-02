Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3EBIZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:25:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23503 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3EBIZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:25:55 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-0e-51822311e566
Date: Thu, 02 May 2013 08:25:53 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH ] MIPS:  Fix build error crash_dump.c file.
To: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lars@metafoo.de
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130502081709416@eunb.song
Msgkey: 20130502081709416@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130502075832647@eunb.song
X-ParentMTR: 20130502075832647@eunb.song
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <417838.192431367483152638.JavaMail.weblogic@epv6ml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Znq6gclOgwY0/BhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj/tkXjAU9vBV3ptY0MN7h6WLk5BASUJFo+f+dEcSWEDCRmLBp
	FhuELSZx4d56IJsLqGYZo8Sr/c/ZYIrO3L/FBJGYzyjxvHEZWDcL0KSr91vAitgEtCXefnnA
	CmILC1hLPNk9kxnEFhHIkti7ZRGYzSwQKdHY/5od4gp5icmnL4PZvAKCEidnPmGBWKYkcf30
	WlaIuLJE3/pnUHEJiVnTL7BC2LwSM9qfQsXlJKZ9XcMMYUtLnJ+1gRHmm8XfH0PF+SWO3d4B
	9AAHWO+T+8EwY3Zv/gL1o4DE1DMHoVrVJY7M/AM1XlPid+MURpgxu04tZ4bpvb9lLhPEW4oS
	U7ofskPYWhJffuxjQ/cWr4CTxPVVP1gnMCrPQpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelFxnp
	FSfmFpfmpesl5+duYoSkhb4djDcPWB9iTAZGyURmKdHkfGBaySuJNzQ2M7IwNTE1NjK3NCNN
	WEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo+QsTov3BxpNdY/YNDGE9gZZHr5f
	8vXiGw3X+G3XD32cd0D0zWVWO/V2JttLoht+vjIyP3tYSfSErMZm1ySxxFvyhbfOec/oWx/4
	r2a7acDDZBPFgM+h1xlenDH8E62y4YZVkYLkqeNvVuwoUmu6VeG/fu70Qkfpq0usheZLrF7D
	cSTwqdWZYCWW4oxEQy3mouJEAGLQ0Z0hAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2dF1B5aZAg62z9Cwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xv2zLxgLengr7kytaWC8w9PFyMkhJKAi0fL/OyOILSFgInHm/i0mCFtM4sK99WxdjFxANfMZ
	JZ43LgMrYgFquHq/hQ3EZhPQlnj75QEriC0sYC3xZPdMZhBbRCBLYu+WRWA2s0CkRGP/a3aI
	ZfISk09fBrN5BQQlTs58wgKxTEni+um1rBBxZYm+9c+g4hISs6ZfYIWweSVmtD+FistJTPu6
	hhnClpY4P2sDI8zRi78/horzSxy7vQPoGQ6w3if3g2HG7N78hQ3CFpCYeuYgVKu6xJGZf6DG
	a0r8bpzCCDNm16nlzDC997fMZYJ4S1FiSvdDdghbS+LLj31s6N7iFXCSuL7qB+sERrlZSFKz
	kLTPQtKOrGYBI8sqRtHUguSC4qT0CiO94sTc4tK8dL3k/NxNjOAE9WzRDsZ/560PMQpwMCrx
	8H7QbQwUYk0sK67MPcQowcGsJMKbJN8UKMSbklhZlVqUH19UmpNafIgxGRiBE5mlRJPzgckz
	ryTe0NjA2NDQ0tzA1NDIgjRhJXHeZ63WgUIC6YklqdmpqQWpRTBbmDg4pRoYywUlqhrc9bgF
	F5juPywTFPnw/A15v6dXFC22xNQlqMxcl9JqIahtZFDWJqGglNliuNlJ5vTtQw7FHfY3kh7E
	T711SsQ17tpnU5mTi1yftU62nef5/MMv2/WPrW/Wth9Ylte5yeHv1qlXJNYHNTxcL+Vw9PYJ
	ix+GcQ+CEtlXnZld7dBi7iipxFKckWioxVxUnAgA/+UNupQDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r428Q6TZ002728


This patch fixes crash_dump.c build error. Build error logs are as follow.

arch/mips/kernel/crash_dump.c: In function 'kdump_buf_page_init':
arch/mips/kernel/crash_dump.c:67: error: implicit declaration of function 'kmalloc'
cc1: warnings being treated as errors
arch/mips/kernel/crash_dump.c:67: error: assignment makes pointer from integer without a cast
make[3]: *** [arch/mips/kernel/crash_dump.o] Error 1
make[2]: *** [arch/mips/kernel] Error 2
make[1]: *** [arch/mips] Error 2
make[1]: *** Waiting for unfinished jobs....
  CC      kernel/sys.o
  CC      kernel/module.o
  GZIP    kernel/config_data.gz
  CHK     kernel/config_data.h
  LD      kernel/built-in.o


Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/mips/kernel/crash_dump.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/crash_dump.c b/arch/mips/kernel/crash_dump.c
index 35bed0d..3be9e7b 100644
--- a/arch/mips/kernel/crash_dump.c
+++ b/arch/mips/kernel/crash_dump.c
@@ -2,6 +2,7 @@
 #include <linux/bootmem.h>
 #include <linux/crash_dump.h>
 #include <asm/uaccess.h>
+#include <linux/slab.h>
 
 static int __init parse_savemaxmem(char *p)
 {
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
