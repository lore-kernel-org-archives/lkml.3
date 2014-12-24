Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaLXFpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 00:45:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63636 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaLXFpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 00:45:44 -0500
X-AuditID: cbfee691-f79b86d000004a5a-93-549a5301c0ef
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 4/4] ARM: dts: Enable USB node for exynos3250-monk
Date: Wed, 24 Dec 2014 14:45:33 +0900
Message-id: <1419399933-3707-5-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1419399933-3707-1-git-send-email-jaewon02.kim@samsung.com>
References: <1419399933-3707-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWyRsSkUJcxeFaIwcRPnBbXvzxntdjRcITV
	ov/xa2aLy7vmsFnMOL+PyWLRslZmi7VH7rI7sHtsWtXJ5tG3ZRWjx+dNcgHMUVw2Kak5mWWp
	Rfp2CVwZW29uZyrYx1ox8/QBpgbG/SxdjJwcEgImEhuPvGOHsMUkLtxbz9bFyMUhJLCUUWLj
	3a2sMEXH7z6DSixilFjeMIsZJCEk0MYksWymN4jNJqAt8X39YqAGDg4RAT+JZS91QeqZBdYz
	SuzYcIsNpEZYwFVi3c//YJtZBFQlZj99wAhi8wq4S/Q/mMwI0ishoCAxZ5INSJhTwEPi6daD
	jBCr3CV+rn3ACjJTQqCfXeLWkZlsEHMEJL5NPsQC0SsrsekAM8TNkhIHV9xgmcAovICRYRWj
	aGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGYECf/vds4g7G+wesDzEKcDAq8fAuODMjRIg1say4
	MvcQoynQhonMUqLJ+cC4ySuJNzQ2M7IwNTE1NjK3NFMS59WR/hksJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgXHBjqqbS6qfsyYyfGqUTjY6XLbqqJ/es28T1swKUG9S2r3+/ad10/40ad8N
	rl/K+/IW347G6T1z73Sc7pqRLpK8JqFAb97fzeEld6KSBHTnWZke4xCN9/iwenbBPp8jj1/t
	/6rgxbb4Z0H91WPVGf8Uz5zPtFn5cHeBwgLnqZGCB5sXy/FezpqsxFKckWioxVxUnAgAIQO2
	+WMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jAV3G4FkhBjOfMlpc//Kc1WJHwxFW
	i/7Hr5ktLu+aw2Yx4/w+JotFy1qZLdYeucvuwO6xaVUnm0ffllWMHp83yQUwRzUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZmy9uZ2pYB9rxczTB5gaGPezdDFyckgImEgc
	v/uMDcIWk7hwbz2QzcUhJLCIUWJ5wyxmkISQQBuTxLKZ3iA2m4C2xPf1i1m7GDk4RAT8JJa9
	1AWpZxZYzyixY8MtsEHCAq4S637+B1vAIqAqMfvpA0YQm1fAXaL/wWRGkF4JAQWJOZNsQMKc
	Ah4ST7ceZIRY5S7xc+0D1gmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfLM+kd
	jKsaLA4xCnAwKvHwLjgzI0SINbGsuDL3EKMEB7OSCK/OjZkhQrwpiZVVqUX58UWlOanFhxhN
	gY6ayCwlmpwPjOW8knhDYxMzI0sjc0MLI2NzJXFeJfu2ECGB9MSS1OzU1ILUIpg+Jg5OqQZG
	x57Qljn3O05YLFntUX/Cojlxxc/MPT0vfutM+nZt0oH3hUmqrPsETXPjCyZfcIuQT/QzWd95
	8MCuJbJ5037n2Z3tV6zJczn0+qqMKItW1LJrFTlyXDd3/NBbsty1V+9B1Rp7jQXSayV0Ui87
	1H3Wrrjb6ngowEVQONt260mZ4uynLLa8jOVKLMUZiYZazEXFiQAGzpObrQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree node for hsotg to control USB 2.0 Device.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 24822aa..0c1d85d 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -134,6 +134,16 @@
 	};
 };
 
+&exynos_usbphy {
+	status = "okay";
+};
+
+&hsotg {
+	vusb_d-supply = <&ldo15_reg>;
+	vusb_a-supply = <&ldo12_reg>;
+	status = "okay";
+};
+
 &i2c_0 {
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
1.7.9.5

