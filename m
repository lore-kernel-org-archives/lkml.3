Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaHTNo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:44:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36258 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaHTNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:55 -0400
X-AuditID: cbfee61a-f79e46d00000134f-1b-53f4a655cbb8
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v5 06/10] DT: Add documentation for exynos4-is 'flashes'
 property
Date: Wed, 20 Aug 2014 15:44:15 +0200
Message-id: <1408542259-415-7-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jAd3QZV+CDU4cs7DYOGM9q8X8I+dY
	LfrfLGS1OPdqJaNF79XnjBZnm96wW1zeNYfNYuubdYwWPRu2slosvX6RyWLC9LUsFq17j7A7
	8HismbeG0eNyXy+Tx8rlX9g8Nq3qZPPo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujMnLb7AW
	rOGuePPjHWMD4yHOLkYODgkBE4mna1S6GDmBTDGJC/fWs3UxcnEICSxilPjX/wPKaWeS2PCq
	iwWkik3AUOLni9dMILaIQLlEz/tnYEXMAouZJKb2vGADSQgLhEv0PrkOVsQioCqxbnUXM8g2
	XgE3iev3EiEWK0jMmWQDYnIKuEtseQ92gxBQwel3s1kmMPIuYGRYxSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iREcjM+kdjCubLA4xCjAwajEw9uw4EuwEGtiWXFl7iFGCQ5mJRHe9k6gEG9K
	YmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBkatqc9U5J99trYy
	nt58gbdoqdxZs3Xcs7lPyT7+pZrX497yVvmd+x/1iX383vvVns6/Gt1THK24ukXsm0zZzGN9
	7y72rM9U25xqzBPsEXNWwu9By16u6D8tLyf0sNT03r9Ru1Jga13B6kQVYXF+meMmap8S5v3a
	+fnm1K7ZD1e4T7c8nsLskaTEUpyRaKjFXFScCABupPbrQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a description of 'flashes' property
to the samsung-fimc.txt.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 922d6f8..387ef3b 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -40,6 +40,10 @@ should be inactive. For the "active-a" state the camera port A must be activated
 and the port B deactivated and for the state "active-b" it should be the other
 way around.
 
+Optional properties:
+
+- flashes - array of phandles to the available flash led devices
+
 The 'camera' node must include at least one 'fimc' child node.
 
 
@@ -166,6 +170,7 @@ Example:
 		clock-output-names = "cam_a_clkout", "cam_b_clkout";
 		pinctrl-names = "default";
 		pinctrl-0 = <&cam_port_a_clk_active>;
+		flashes = <&max77693-flash>, <&aat1290>;
 		status = "okay";
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.9.5

