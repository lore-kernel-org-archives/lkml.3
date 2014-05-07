Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaEGIJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:09:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58039 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaEGIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:09:15 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-a5-5369ea298d92
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Pawel Moll'" <pawel.moll@arm.com>
References: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
In-reply-to: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
Subject: [PATCH 5/5] regulator: vexpress: Make of_device_id array const
Date: Wed, 07 May 2014 17:09:12 +0900
Message-id: <01ef01cf69cb$a1a66d30$e4f34790$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pyau3FkiFWFjRR4iSx3x0aUKqEQAAeCOQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zQ13NV5nBBtMmslhMffiEzeLywkus
	Ft+udDBZXN41h81iwvS1LA6sHmvmrWH02DnrLrvHplWdbB59W1YxenzeJBfAGsVlk5Kak1mW
	WqRvl8CV0fJqL3PBGdaKaau3MjUwXmXpYuTgkBAwkZhxP6SLkRPIFJO4cG89WxcjF4eQwDJG
	iU/HLrDC1Dz8JgcRX8QoceXvfnYI5zejxM9LX9lAutkE1CS+fDnMDtIgIqAq8f+VO0iYWWAC
	o8SLJ5YgYSEBW4lHe+pBwpwCdhIN26aCdQoLuEt8WPqYGcRmAeq8+WEJK4jNC1T+bMsbdghb
	UOLH5HssECO1JNbvPM4EYctLbF7zlhniTHWJR391QcIiAkYSd9qfM0OUiEjse/GOEeRiCYFb
	7BK/7i1jh9glIPFt8iFoMMhKbDrADAkGSYmDK26wAN09C8nmWUg2z0KyeRaSFQsYWVYxiqYW
	JBcUJ6UXGesVJ+YWl+al6yXn525ihMRo/w7GuwesDzEmA62fyCwlmpwPjPG8knhDYzMjC1MT
	U2Mjc0sz0oSVxHnvP0wKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cA4+8YVMfnwuIKZu1yW
	Lp1VuOx0xbWtKu84jj85cuVXhKXP99//PPgXvv1wwLxMc4bzuyBvRd7vchuSov8qC9mm3N0c
	uuDymqSnM2/OMeKy+Xqd1d3hXChnrKlcb+Wa/ef3qNefm+L71a1sU+vESMZXNxaf+JOb/3/F
	u2UyJsVztb6WbfMt39Vdp8RSnJFoqMVcVJwIAAkeWB/nAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jAV3NV5nBBoeMLKY+fMJmcXnhJVaL
	b1c6mCwu75rDZjFh+loWB1aPNfPWMHrsnHWX3WPTqk42j74tqxg9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMaHm1l7ngDGvFtNVbmRoYr7J0MXJwSAiYSDz8
	JtfFyAlkiklcuLeerYuRi0NIYBGjxJW/+9khnN+MEj8vfWUDqWITUJP48uUwO0iziICqxP9X
	7iBhZoEJjBIvnliChIUEbCUe7akHCXMK2Ek0bJsK1iks4C7xYeljZhCbBajz5oclrCA2L1D5
	sy1v2CFsQYkfk++xQIzUkli/8zgThC0vsXnNW2aIk9UlHv3VBQmLCBhJ3Gl/zgxRIiKx78U7
	xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4ATyT3sG4
	qsHiEKMAB6MSD6/F24xgIdbEsuLK3EOMEhzMSiK8uy5mBgvxpiRWVqUW5ccXleakFh9iTAZ6
	dCKzlGhyPjA55ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD
	Y9uklz5Wk/VFLr16FhrbMGNDiHRYjbDCU8FPmjuOS7n+mRp7bqmCJU9ozQbLGydnSO2IqZES
	yVaqVelYnLyPtf2QNHfYzGgubanP5Yp8016UnbXT4df5+tVVK2z1/kUhDDkepnkv3V5Uz55y
	KGeRm0xb/8KJ7wukTy7R0Pz5bPlcyajnUWs+KrEUZyQaajEXFScCAINmWHFEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/vexpress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/vexpress.c b/drivers/regulator/vexpress.c
index f3ae28a..147ecc7 100644
--- a/drivers/regulator/vexpress.c
+++ b/drivers/regulator/vexpress.c
@@ -123,7 +123,7 @@ static int vexpress_regulator_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id vexpress_regulator_of_match[] = {
+static const struct of_device_id vexpress_regulator_of_match[] = {
 	{ .compatible = "arm,vexpress-volt", },
 	{ }
 };
-- 
1.7.10.4


