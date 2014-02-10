Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaBJBK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:10:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:63856 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaBJBK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:10:57 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-c8-52f8272014db
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Thierry Reding'" <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003901cf25fc$73002790$590076b0$%han@samsung.com>
In-reply-to: <003901cf25fc$73002790$590076b0$%han@samsung.com>
Subject: [PATCH 3/7] ARM: remove HAVE_PWM config option
Date: Mon, 10 Feb 2014 10:10:56 +0900
Message-id: <003c01cf25fc$f3a707b0$daf51710$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8l/GYGhOsBgXmsQoSPhLhnprg0iAAAFzHg
Content-language: ko
x-cr-hashedpuzzle: FEg0 F098 GiXp IYH9 JnrL KBNJ OOqy OXq4 ilOR jzIt klO2 lmyd
 p0Kf t0+D xYBS
 7zj9;5;YQByAG4AZABAAGEAcgBuAGQAYgAuAGQAZQA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBhAHIAbQAtAGsAZQByAG4AZQBsAEAAbABpAHMAdABzAC4AaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwB0AGgAaQBlAHIAcgB5AC4AcgBlAGQAaQBuAGcAQABnAG0AYQBpAGwALgBjAG8AbQA=;Sosha1_v1;7;{7C03F880-BE95-4A89-8998-EAD19386ED3D};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 10 Feb 2014 01:10:47
 GMT;WwBQAEEAVABDAEgAIAAzAC8ANwBdACAAQQBSAE0AOgAgAHIAZQBtAG8AdgBlACAASABBAFYARQBfAFAAVwBNACAAYwBvAG4AZgBpAGcAIABvAHAAdABpAG8AbgA=
x-cr-puzzleid: {7C03F880-BE95-4A89-8998-EAD19386ED3D}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zA10F9R9BBjv2mVn8nXSM3eLywkus
	FpseX2O1uLxrDpvFz13zWBxYPX7/msTosXPWXXaPzUvqPfq2rGL0+LxJLoA1issmJTUnsyy1
	SN8ugStj4xT9gnWsFQsnzWNrYFzO0sXIySEhYCIx9dkyNghbTOLCvfVANheHkMAyRon2ruNw
	RWtvzGKFSCxilDgzbTNU1S9Gif+vHjGCVLEJqEl8+XKYHcQWEVCWOP7yDgtIEbPATEaJp+9e
	ge0QErCVmNuwH6yIU8BOYt7Sb6wgtrCAucTp/VfB1rEIqEo0PjwFZvMC1d/8840NwhaU+DH5
	HlicWUBLYv3O40wQtrzE5jVvmbsYOYBOVZd49FcX4gYjif+3zjBDlIhI7HvxjhHkHgmBPawS
	97r3Qv1sKnH55zNmiMRPdomud/dYIY4QkPg2+RALxFBZiU0HmCHqJSUOrrjBMoFRahaSk2Yh
	OWkWkpNmIdm9gJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIbPfuYLx9wPoQYzLQ+onM
	UqLJ+cDUkFcSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjH1V4R5Tv87fmL/tusV2Ua/utSfqfDOdm5/3WNub633Wz1xXmsZZ89TR8nAUh8il+Ou5
	YerLRBZ1S3CmRtlInb9cZ67ocSlLliHuQFR6n+b/fK/vfCp3NIUO/2O/ab1f7crXL0r9uy9k
	Nc5I3Ojnef/9A+v/R/5Gnf7msl11ym0zvS2S9U95lViKMxINtZiLihMBCiY83wMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jAV0F9R9BBsueG1n8nXSM3eLywkus
	FpseX2O1uLxrDpvFz13zWBxYPX7/msTosXPWXXaPzUvqPfq2rGL0+LxJLoA1qoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdouZJCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+MU/YJ1rBULJ81ja2BcztLFyMkhIWAisfbG
	LFYIW0ziwr31bF2MXBxCAosYJc5M2wzl/GKU+P/qESNIFZuAmsSXL4fZQWwRAWWJ4y/vsIAU
	MQvMZJR4+u4VG0hCSMBWYm7DfrAiTgE7iXlLv4GtEBYwlzi9/yrYahYBVYnGh6fAbF6g+pt/
	vrFB2IISPybfA4szC2hJrN95nAnClpfYvOYtcxcjB9Cp6hKP/upC3GAk8f/WGWaIEhGJfS/e
	MYLcIyGwh1XiXvdeNojXTCUu/3zGPIFRZBaSFbOQrJiFZMUsJLMWMLKsYhRNLUguKE5KzzXS
	K07MLS7NS9dLzs/dxAhOHM+kdzCuarA4xCjAwajEw7vjz/cgIdbEsuLK3EOMEhzMSiK8L+8C
	hXhTEiurUovy44tKc1KLDzEmA0NgIrOUaHI+MKnllcQbGpuYGVkamVkYmZibkyasJM57sNU6
	UEggPbEkNTs1tSC1CGYLEwenVAOjINuc9tm8HzW3im4pjLuSPC+B7a7f/4NJK7KnqbWt7HFS
	/NNY+2j1bYnzH5IWmtuvazQNrVjXb5con31GZaX3xhstwk1O86SOsb1nXnVYl6t7vc2Dyf5a
	ZTpuvUaNfVtd9v18k3+36mBxZ7Zwe4CinGPp54A0o6gt56S2LJf7sS0+TuinuYgSS3FGoqEW
	c1FxIgCZhqQ8YAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HAVE_PWM symbol is only for legacy platforms that provide
the PWM API without using the generic framework. However, legacy
PWM drivers for ARM platforms were already moved to the generic
PWM framework. Thus, HAVE_PWM should be removed, because HAVE_PWM
is not required anymore.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 897fa15..cc6ce44 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -113,9 +113,6 @@ config ARM_DMA_IOMMU_ALIGNMENT
 
 endif
 
-config HAVE_PWM
-	bool
-
 config MIGHT_HAVE_PCI
 	bool
 
-- 
1.7.10.4


