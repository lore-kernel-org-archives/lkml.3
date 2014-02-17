Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaBQJse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:48:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14618 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaBQJpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:45:17 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-5e-5301da2b933e
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 6/9 v7] ARM: dts: exynos5250/5420: add dt node for sss module
Date: Mon, 17 Feb 2014 15:14:32 +0530
Message-id: <1392630275-8667-7-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkTlf7FmOwwYNWG4uXhzQt5pxvYbHo
	fiVj0bvgKpvF/Xs/mSwu75rDZjHj/D4mi0Xb/jNbnJ1ziMmB02PLyptMHjtn3WX32HZA1aNv
	yypGj8+b5AJYo7hsUlJzMstSi/TtErgy1q6azlgwh6di3Zu7TA2MfVxdjJwcEgImEgf/LWCC
	sMUkLtxbz9bFyMUhJLCUUeLSrSZ2mKLOa+sYIRKLGCUedP1ggXD6mSQmLDzABlLFJmAmcXDR
	arAOEQFnid/Na1hBipgF9jFKXOs9DpYQFvCVOLBlLdAoDg4WAVWJBX/kQMK8Ai4Sayd2s4KE
	JQQUJOZMsgEJcwq4SnTe2c4CYgsBlazrvAS2V0JgHbvE8wuzGEESLAICEt8mH2KB6JWV2HSA
	GeJoSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMOhP/3s2cQfj/QPW
	hxiTgcZNZJYSTc4HRk1eSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NTC1KL4otK
	c1KLDzEycXBKNTDquXg/XtktXp82NfzyM+n9bWvuBr6dKfbk4LsZzeyxevdZax5Lbf88X2Jp
	q5tKlKe3wUH7OQGvp3Jd81tbvlJ6SXmlAwfDnnTBx+7vw+4oTvfofxB502uh/edqq0sflk82
	8mHmPHVw04f/z95uU3F3bLhR4ex1U9dj/36mghXZl0utw95/nztJiaU4I9FQi7moOBEA/7zM
	WZACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAV3tW4zBBovfGlu8PKRpMed8C4tF
	9ysZi94FV9ks7t/7yWRxedccNosZ5/cxWSza9p/Z4uycQ0wOnB5bVt5k8tg56y67x7YDqh59
	W1YxenzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPtqumMBXN4
	Kta9ucvUwNjH1cXIySEhYCLReW0dI4QtJnHh3nq2LkYuDiGBRYwSD7p+sEA4/UwSExYeYAOp
	YhMwkzi4aDU7iC0i4Czxu3kNK0gRs8A+RolrvcfBEsICvhIHtqwFGsvBwSKgKrHgjxxImFfA
	RWLtxG5WkLCEgILEnEk2IGFOAVeJzjvbWUBsIaCSdZ2XWCYw8i5gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERxTz6R3MK5qsDjEKMDBqMTD21nLGCzEmlhWXJl7iFGCg1lJhNd2HVCI
	NyWxsiq1KD++qDQntfgQYzLQTROZpUST84HxnlcSb2hsYm5qbGppYmFiZkmasJI478FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjJKPwhUXdP7/ZyzZrL38r5LHoZdxof++Rq41lQs+cuDVjtxL
	lxW0/y73tGR8eCNsfuxlxqzNCz6LZwjkyfLv5RdTYEurPMYpX/WCb87eJo1G133G096L7szh
	XbyXYZvclasHE253bF26Jaw5ZN/GH8VXpef4rts+6Y39QruAdXOXTizfkZr1Tk+JpTgj0VCL
	uag4EQDFO+IM7QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree node for SSS module
found on Exynos5420 and Exynos5250

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
CC: David S. Miller <davem@davemloft.net>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
Changes since v6:
None

 arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
 arch/arm/boot/dts/exynos5420.dtsi |    9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index a76a189..13b748f 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -715,4 +715,12 @@
 		io-channel-ranges;
 		status = "disabled";
 	};
+
+	sss@10830000 {
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 348>;
+		clock-names = "secss";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 9c834cc..b4ce625 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -666,4 +666,13 @@
 		clock-names = "watchdog";
 		samsung,syscon-phandle = <&pmu_system_controller>;
         };
+
+	sss@10830000 {
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+		samsung,power-domain = <&g2d_pd>;
+	};
 };
-- 
1.7.9.5

