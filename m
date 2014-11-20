Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbaKTNcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:32:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58085 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaKTNc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:32:26 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-e0-546ded662b82
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 2/2] ARM: dts: Add regulator-haptic device node for
 exynos3250-rinato
Date: Thu, 20 Nov 2014 22:31:40 +0900
Message-id: <1416490300-28865-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416490300-28865-1-git-send-email-jaewon02.kim@samsung.com>
References: <1416490300-28865-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWyRsSkWDftbW6Iwfan2hbXvzxntTi86AWj
	xY6GI6wWvQuuslnc/PSN1eLyrjlsFjPO72NyYPfYOesuu0ffllWMHp83yQUwR3HZpKTmZJal
	FunbJXBlHO95yVSwjrWi5+IH9gbGLSxdjJwcEgImEs9+74ayxSQu3FvP1sXIxSEksJRRYsqt
	DUwwRf8WzmOFSExnlNjTto4dwmljkvj+7TxYO5uAtsT39YtZQWwRgVCJ3tefwYqYBTYySnyd
	cwMsISwQLrFk7XtmEJtFQFXif+8edhCbV8BD4seVXsYuRg6gdQoScybZgIQ5BTwl+t+/YgSx
	hYBKFqw5xwIyU0Kgm13izatuRog5AhLfJh9igeiVldh0gBniakmJgytusExgFF7AyLCKUTS1
	ILmgOCm9yESvODG3uDQvXS85P3cTIzCoT/97NmEH470D1ocYBTgYlXh4EyxyQ4RYE8uKK3MP
	MZoCbZjILCWanA+MnbySeENjMyMLUxNTYyNzSzMlcd7XUj+DhQTSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTCmHokN2jtPZ+62U+z3vF6JMtyb8vuxglfJK20efTuji/7/7J69LOfeE/RMfMoe
	Dg/vX5xcGUZRP5Y67b0149iU3geT5+kUrb66tuqLvfLMkx/M72cVrHvrp7LB6TSHz3v1M1Ov
	f5nV3n9o3mw9bvEvXtJcsuxXLP6/bJnr5FD/JmTumxMTpEu+KbEUZyQaajEXFScCAH4yCPFl	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t9jQd20t7khBh3tqhbXvzxntTi86AWj
	xY6GI6wWvQuuslnc/PSN1eLyrjlsFjPO72NyYPfYOesuu0ffllWMHp83yQUwRzUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZhzveclUsI61oufiB/YGxi0sXYycHBICJhL/
	Fs5jhbDFJC7cW8/WxcjFISQwnVFiT9s6dginjUni+7fzYB1sAtoS39cvBusQEQiV6H39GayI
	WWAjo8TXOTfAEsIC4RJL1r5nBrFZBFQl/vfuYQexeQU8JH5c6WXsYuQAWqcgMWeSDUiYU8BT
	ov/9K0YQWwioZMGacywTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOmWdSOxhX
	NlgcYhTgYFTi4U2wyA0RYk0sK67MPcQowcGsJMKrsRMoxJuSWFmVWpQfX1Sak1p8iNEU6KiJ
	zFKiyfnAeM4riTc0NjEzsjQyN7QwMjZXEue9cROoSSA9sSQ1OzW1ILUIpo+Jg1OqgdFYM+Xn
	4Ukp++b+NV4oJSLzc1eiWk5yavhVh+0bjY5de1uZc3f6IuNfs5/o7d91qcHK/4TPqty3zzOV
	V4p/4yk+kXs+dOL9DVERG8Kzk/ZP2rfkjvX+rzuvnV6r3/rRJ7JPu2mWkBLXR/PfTqukL9f9
	/885ecdNlr9Z03LCn7YVqwnv3N2m471NiaU4I9FQi7moOBEAxkODEK8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds regulator-haptic device node controlled by regulator.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 84380fa..8172815 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -104,6 +104,13 @@
 			};
 		};
 	};
+
+	regulator-haptic {
+		compatible = "regulator-haptic";
+		haptic-supply = <&motor_reg>;
+		min-microvolt = <1100000>;
+		max-microvolt = <2700000>;
+	};
 };
 
 &adc {
-- 
1.7.9.5

