Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaKXNPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:15:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:28071 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaKXNPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:15:34 -0500
X-AuditID: cbfee68e-f79b46d000002b74-46-54732f744143
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 05/12] soc: samsung: pm_domain: Use unique compatible
 name for power domain
Date: Mon, 24 Nov 2014 18:34:09 +0530
Message-id: <1416834256-11225-5-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkRrdEvzjEoOmesUXD1RCL+UfOsVo8
	u7WXyaJ3wVU2i6ebHzNZbHp8jdXi8q45bBafe48wWsw4v4/JYtHWL+wWZ05fYrU4/Kad1eL4
	2nAHXo9NqzrZPO5c28PmcehwB6PH5iX1HluutrN49G1ZxejxeZNcAHsUl01Kak5mWWqRvl0C
	V8bRzV/ZCq6KVOz+/469gfGTQBcjJ4eEgInE3hn7GCFsMYkL99azdTFycQgJLGWUmPvhMjNM
	0ZEzJ9lAbCGB6YwSX0/mQxRNYJLY8+ceC0iCTcBY4ufO/exdjBwcIgLeEsuvKYLUMAusZpLY
	2v6BCaRGWCBFYunUi2D1LAKqEisfNDKC1PMKuEssf2YBYkoIKEjMmWQDUsEp4CHx4mALM8Sq
	FkaJS4/nsoI4EgLX2CUWvzrGCjFHQOLb5EMsEM2yEpsOQN0sKXFwxQ2WCYzCCxgZVjGKphYk
	FxQnpRcZ6RUn5haX5qXrJefnbmIExsvpf8/6djDePGB9iFGAg1GJh/fDxqIQIdbEsuLK3EOM
	pkAbJjJLiSbnA6MyryTe0NjMyMLUxNTYyNzSTEmcN0HqZ7CQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGRveO4+fefL817+lOpRy5YsWep+XLuXd/uf2iZquaOY/oplV8s9q2z/GcPKM860mp
	Knf1tRXOLsI3n7+sirXfvaJ0KkfhNsWaeG2p7V+Kflh+2jydI67v/JZ9HIbij7Zvn3xjTs9e
	binvFXdPbfv85NHh17G7bzAU/iudPPX1hLqz+XeTItb2qXEpsRRnJBpqMRcVJwIA1DiRxpIC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jQd0S/eIQg9cTtCwaroZYzD9yjtXi
	2a29TBa9C66yWTzd/JjJYtPja6wWl3fNYbP43HuE0WLG+X1MFou2fmG3OHP6EqvF4TftrBbH
	14Y78HpsWtXJ5nHn2h42j0OHOxg9Ni+p99hytZ3Fo2/LKkaPz5vkAtijGhhtMlITU1KLFFLz
	kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
	YZoQGuKmawHTGKHrGxIE12NkgAYS1jBmHN38la3gqkjF7v/v2BsYPwl0MXJySAiYSBw5c5IN
	whaTuHBvPZgtJDCdUeLryfwuRi4gewKTxJ4/91hAEmwCxhI/d+5n72Lk4BAR8JZYfk0RpIZZ
	YDWTxNb2D0wgNcICKRJLp14Eq2cRUJVY+aCREaSeV8BdYvkzCxBTQkBBYs4kG5AKTgEPiRcH
	W5ghVrUwSlx6PJd1AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB0fhMegfjqgaL
	Q4wCHIxKPLwz1heFCLEmlhVX5h5ilOBgVhLhFRMrDhHiTUmsrEotyo8vKs1JLT7EaAp01ERm
	KdHkfGCiyCuJNzQ2MTc1NrU0sTAxs1QS571xMzdESCA9sSQ1OzW1ILUIpo+Jg1OqgZG1wWNP
	koDTTzU39ln3tT0u3zRY2bYubNOupWuv7liw8LruhP1HXRxuZaVuf/v3/ILE00pPWVoFnu+6
	tf2gdgzn0unXuqwuX807vZA3KeE0f11mnv+W6PMKN06r7apX2/n32vX7aw+3y9Y9DFNi2c50
	K2S5I5v5B6urZ3h2zhA7tqA8KOKnz9wsJZbijERDLeai4kQAEoXtDdwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for second optional compatible complate name. If
this compatible name is present then this name will be used to create
the Power Domain and not the DT node name. This will be useful to carry
out any power domain specific changes in the PD on/off handlers for new
SoCs.
This change will not affect the existing DT bindings.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 .../bindings/arm/exynos/power_domain.txt           |    8 ++++++++
 drivers/soc/samsung/pm_domains.c                   |   10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
index abde1ea..00ebda1 100644
--- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
@@ -12,6 +12,8 @@ Required Properties:
     must be 0.
 
 Optional Properties:
+- compatible: This is a second compatible name and gives the complete Power
+	Domain name like "samsung,exynos7-pd-mfc".
 - clocks: List of clock handles. The parent clocks of the input clocks to the
 	devices in this power domain are set to oscclk before power gating
 	and restored back after powering on a domain. This is required for
@@ -43,5 +45,11 @@ Example:
 		#power-domain-cells = <0>;
 	};
 
+	mfc_pd: power-domain@10044060 {
+		compatible = "samsung,exynos4210-pd", "samsung,exynos7-pd-mfc";
+		reg = <0x10044060 0x20>;
+		#power-domain-cells = <0>;
+	};
+
 See Documentation/devicetree/bindings/power/power_domain.txt for description
 of consumer-side bindings.
diff --git a/drivers/soc/samsung/pm_domains.c b/drivers/soc/samsung/pm_domains.c
index 69bc8b1..f4f2a6c 100644
--- a/drivers/soc/samsung/pm_domains.c
+++ b/drivers/soc/samsung/pm_domains.c
@@ -120,12 +120,20 @@ static int exynos_power_domain_probe(struct platform_device *pdev)
 		struct exynos_pm_domain *pd;
 		int i;
 		bool on;
+		const char *name;
 
 		pd = devm_kzalloc(&pdev->dev, sizeof(*pd), GFP_KERNEL);
 		if (!pd)
 			return -ENOMEM;
 
-		pd->pd.name = kstrdup(np->name, GFP_KERNEL);
+		/*
+		 * Check if second compatible name found then use as power
+		 * domain name or else use the DT node name as before.
+		 */
+		if (of_property_read_string_index(np, "compatible", 1, &name))
+			name = np->name;
+
+		pd->pd.name = kstrdup(name, GFP_KERNEL);
 		pd->name = pd->pd.name;
 		pd->base = of_iomap(np, 0);
 		pd->pd.power_off = exynos_pd_power_off;
-- 
1.7.9.5

