Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3HBFU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 01:20:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17622 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3HBFU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 01:20:56 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-4d-51fb41b4baae
From: Jingoo Han <jg1.han@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/2] mfd: ab8500-gpadc: add CONFIG_PM_RUNTIME to
 runtime_suspend/runtime_resume
Date: Fri, 02 Aug 2013 14:20:51 +0900
Message-id: <000101ce8f40$0e118070$2a348150$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6PQAYGVuNwBnQcSWmjT0yFTwBTOA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI90tjr8DDe7f5rK4vPASq8X9r0cZ
	LS7vmsNmcbqb1YHF4861PWwe804GevRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG8hlpBdu4
	KhZs+8vSwPiFo4uRk0NCwETi1cP/bBC2mMSFe+vBbCGBZYwSBw4HwdRcXv2TESK+iFFi8mkX
	CPsXo8SKw5ogNpuAmsSXL4fZuxg5OEQEvCRu3QFrZRZwkvi5ZSYLiC0skCjx6e0hVhCbRUBV
	YvPCViYQm1fAUuJ25zVmCFtQ4sfkeywQvVoS63ceZ4Kw5SU2r3nLDHGOgsSOs68ZIVbpSXT0
	i0KUiEjse/EOKMwFVLKKXeLL9SZGiF0CEt8mH2IBqZcQkJXYdABqjKTEwRU3WCYwis1CsnkW
	ks2zkGyehWTFAkaWVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxghkdW7g/H2AetDjMlA6ycy
	S4km5wMjM68k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjAaSdbfc5+570N3A7MsbstbxWjdXqaLOlj6Fz32pjCnvnwh1bFmzpW32yms8+/tKr83b
	fXIrz6xbanmfJ9alc931ltnUlOM/Y18h58Z1Rad0uHmdP3+eO+GSa9jDqdGcDQFPXT00sniP
	bnU358i8eDYhrtG2t77r1MF9C8LVJmybvVJ81wSGM0osxRmJhlrMRcWJAO5dPgHCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO4Wx9+BBl9+sVlcXniJ1eL+16OM
	Fpd3zWGzON3N6sDicefaHjaPeScDPfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4xY/mMtIJtXBULtv1laWD8wtHFyMkhIWAicXn1T0YIW0ziwr31bCC2
	kMAiRonJp10g7F+MEisOa4LYbAJqEl++HGbvYuTgEBHwkrh1JwgkzCzgJPFzy0wWEFtYIFHi
	09tDrCA2i4CqxOaFrUwgNq+ApcTtzmvMELagxI/J91ggerUk1u88zgRhy0tsXvOWGeIcBYkd
	Z18zQqzSk+joF4UoEZHY9+Id4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yY
	W1yal66XnJ+7iREcuc+kdzCuarA4xCjAwajEw/sg81egEGtiWXFl7iFGCQ5mJRHeP7OBQrwp
	iZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTCp5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJI
	TyxJzU5NLUgtgtnCxMEp1cC47V7JWYM7+R2XrQOef+k1ZX93qHzG3Bd3D+QZKGVItRit+Hpj
	4zkLi8OtjSq/S7mWMv7UvpB9JGWfQuBG3T3fvdjy1tnnizi831j4Q6/wXq6ysrHXr9mTrZju
	2x+qqX9jfm5ehfiG3qcaW5a1L5GdN7luO7dVlq/ygc6a7qjDiQbfnndc47unxFKckWioxVxU
	nAgA0ThU8yADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_RUNTIME to runtime_suspend/runtime_resume functions
to fix the build warnings when CONFIG_PM_RUNTIME is not selected.
This is because runtime PM callbacks defined by SET_RUNTIME_PM_OPS
are only used when the CONFIG_PM_RUNTIME is enabled.

drivers/mfd/ab8500-gpadc.c:870:12: warning: 'ab8500_gpadc_runtime_suspend' defined but not used [-Wunused-function]
drivers/mfd/ab8500-gpadc.c:878:12: warning: 'ab8500_gpadc_runtime_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/ab8500-gpadc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 7623e91..77c616f 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -867,6 +867,7 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 		gpadc->cal_data[ADC_INPUT_VBAT].offset);
 }
 
+#ifdef CONFIG_PM_RUNTIME
 static int ab8500_gpadc_runtime_suspend(struct device *dev)
 {
 	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
@@ -885,6 +886,7 @@ static int ab8500_gpadc_runtime_resume(struct device *dev)
 		dev_err(dev, "Failed to enable vtvout LDO: %d\n", ret);
 	return ret;
 }
+#endif
 
 static int ab8500_gpadc_suspend(struct device *dev)
 {
-- 
1.7.10.4


