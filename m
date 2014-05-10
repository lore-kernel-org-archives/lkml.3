Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaEJG24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:28:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43589 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaEJG2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:28:12 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-5b-536dc6fbaae1
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, Rob Landley <rob@landley.net>
Subject: [PATCH v3 3/3] Documentation: update samsung pmu binding information
Date: Sat, 10 May 2014 15:46:25 +0900
Message-id: <1399704385-12508-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704385-12508-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704385-12508-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t8zI93fx3KDDdqnWFgsm3SXzWL+kXOs
	Fr0LrrJZ7Nxyg81i0+NrrBaXd81hs5hxfh+TxZOFZ5gsFm39wm6x7uV0FovWvUfYLdbPeM1i
	saNlNYsDr8emVZ1sHq9Wz2T12Lyk3mPn9wZ2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MqY
	/eMXe8FizoqXTQvYGhifs3cxcnJICJhIbN47nQXCFpO4cG89WxcjF4eQwDJGiVNf17J2MXKA
	Fd37rw0RX8Qose7FD6iiNiaJSys+gE1iE9CVePJ+LjNIQkSgnVHi39WHYFXMApOZJG4tWg22
	Q1jAV2LZ06tgHSwCqhKrF55gBrF5BTwklq89zAyxTkFiziQbkDCngKfExo+LwVqFgEp2tBxi
	BZkpIXCJXaJl1WRWiDkCEt8mH2KB6JWV2HSAGeIdSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3I
	VK84Mbe4NC9dLzk/dxMjJFom7mC8f8D6EGMy0LiJzFKiyfnAaMsriTc0NjOyMDUxNTYytzQj
	TVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBka1/pioDS/s3C7u+XAoRpXh92f7
	hmdTb9yR/vqqXqlH7TLH1sZPaYImXBpZ+x5Z6DHf4V3S6DZL07DBdpL30z3C81u+1ct7eE3s
	L/lywbLOLG/T7Nr2kJTkGfMPKfDme0mYn/cvZF67/Z3lpjRZXefnkenLugykuoKL+eJNry9s
	qZ1k2nd/uhJLcUaioRZzUXEiAO6QPWqsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jAd3fx3KDDSY9MrZYNukum8X8I+dY
	LXoXXGWz2LnlBpvFpsfXWC0u75rDZjHj/D4miycLzzBZLNr6hd1i3cvpLBate4+wW6yf8ZrF
	YkfLahYHXo9NqzrZPF6tnsnqsXlJvcfO7w3sHn1bVjF6fN4kF8AW1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0qZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsI4xY/aPX+wFizkrXjYtYGtgfM7excjBISFgInHvv3YXIyeQ
	KSZx4d56ti5GLg4hgUWMEute/IBy2pgkLq34wA5SxSagK/Hk/VxmkISIQDujxL+rD8GqmAUm
	M0ncWrSaBaRKWMBXYtnTq2AdLAKqEqsXnmAGsXkFPCSWrz3MDLFaQWLOJBuQMKeAp8TGj4vB
	WoWASna0HGKdwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwLD6T2sG4ssHiEKMA
	B6MSD2/B25xgIdbEsuLK3EOMEhzMSiK8Kw7mBgvxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhy
	PjBN5JXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDI9uhnFQ7
	gxMuVzY7HN6/XuO8l8q166+098+MU9Bh3JCodDXklOO6arHVF15fWupwPU/89RzFP3+qon7Y
	rbiSHW5879l8Hv68XwolrKfMGspNY9+YcHQqi7n28jJprejaKXuxqOWg8qJIX16dn2mNe15O
	a08oFLxx8ZTaYj0vn1sPI8KOqU49ocRSnJFoqMVcVJwIAAjs/dcJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates samsung pmu (power management unit) binding information.

CC: Leela Krishna Amudala <l.krishna@samsung.com>
CC: Tomasz Figa <t.figa@samsung.com>
CC: Guenter Roeck <linux@roeck-us.net>
CC: Rob Landley <rob@landley.net>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 Documentation/devicetree/bindings/arm/samsung/pmu.txt |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
index f1f1552..b562634 100644
--- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
@@ -2,6 +2,9 @@ SAMSUNG Exynos SoC series PMU Registers
 
 Properties:
  - compatible : should contain two values. First value must be one from following list:
+		   - "samsung,exynos4210-pmu" - for Exynos4210 SoC,
+		   - "samsung,exynos4212-pmu" - for Exynos4212 SoC,
+		   - "samsung,exynos4412-pmu" - for Exynos4412 SoC,
 		   - "samsung,exynos5250-pmu" - for Exynos5250 SoC,
 		   - "samsung,exynos5420-pmu" - for Exynos5420 SoC.
 		second value must be always "syscon".
-- 
1.7.10.4

