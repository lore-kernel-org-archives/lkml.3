Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaDOOZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:25:22 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62704 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbaDOOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:25:15 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-0d-534d4147d59f
Message-id: <534D4143.3050801@samsung.com>
Date: Tue, 15 Apr 2014 16:25:07 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Ben Dooks'" <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        j.anaszewski@samsung.com,
        =?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>
Subject: [PATCH] arm: dts: exynos4412-trats2: rename alias for i2c_ak8975 label
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xq7rujr7BBm33FS02zljPajFp3QEm
	i/lHzrFa9L9ZyGpx7tVKRoveq8+BxIKrbBZnm96wW2x6fI3V4vKuOWwWM87vY7K4fZnXYun1
	i0wWE6avZbFo3XuE3YHfY828NYweLc09bB6X+3qZPP6uesHssXL5FzaPTas62Tw2L6n36Nuy
	itHj8ya5AM4oLpuU1JzMstQifbsErox9Z5cyF/xlrbh0bhZrA2MLaxcjJ4eEgInEkiP72CFs
	MYkL99azgdhCAksZJc7Oze1i5AKyPzNKbGrZyAyS4BXQkujpvQ9mswioShz/shlsEBvQoGNL
	PjOC2KICERJzJ25mg6gXlPgx+R4LiC0CVPOgtRcsziywj0Vi3zSwxcIC/hINu8+wQMTVJSbN
	W8QMYctLbF7zlnkCI98sJKNmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ
	SPm6g3HpMatDjAIcjEo8vBPeeQcLsSaWFVfmHmKU4GBWEuH9yO0bLMSbklhZlVqUH19UmpNa
	fIiRiYNTqoFRTmX2IoOSvQ8Vfzv8/Xs0d7KeaHuw6a1vSgniWgYG7ltFHktefnn1gIfmHbG6
	b4frHQWe7m1ubsqr9z12g4ntHMufL607/qQv7duStVt2eWx5qeMOK8v026tPPjg89dD5/L9B
	jH9bVvo80L0ttYKXPdZ+5usNR5qeeSfZblXcs1WVoy/T2EtRiaU4I9FQi7moOBEAlHETJ3IC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_ak8975 controler uses label i2c8.
This alias is already used for I2C controller 8 defined
in file arch/arm/boot/dts/exynos4.dtsi.

This patch renames a label for i2c_ak8975 to i2c9.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index c16b315..5add765 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -20,7 +20,7 @@
 	compatible = "samsung,trats2", "samsung,exynos4412", "samsung,exynos4";

 	aliases {
-		i2c8 = &i2c_ak8975;
+		i2c9 = &i2c_ak8975;
 	};

 	memory {
