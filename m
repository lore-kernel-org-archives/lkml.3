Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892AbbAIPZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:25:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55145 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbbAIPZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:25:02 -0500
X-AuditID: cbfee61a-f79c06d000004e71-e8-54aff2cc0366
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v10 17/19] DT: Add documentation for exynos4-is 'flashes'
 property
Date: Fri, 09 Jan 2015 16:23:07 +0100
Message-id: <1420816989-1808-18-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jQd2zn9aHGJxYzWyxccZ6VoujOycy
	Wcw/co7Vov/NQlaLc69WMlr0Xn3OaHG26Q27xeVdc9gstr5Zx2jRs2Erq8XS6xeZLO6eOspm
	MWH6WhaL1r1H2C1273rKanH4TTurxZn9K9kcBD3WzFvD6HG5r5fJY+esu+weK5d/YfM4/HUh
	i8emVZ1sHnvm/2D16NuyitFjxerv7B6fN8kFcEVx2aSk5mSWpRbp2yVwZUy/tp2x4ChPxYvd
	f9kaGI9ydTFyckgImEh0HXrDAmGLSVy4t56ti5GLQ0hgOqNE94bXzBBOO5PEm403mUGq2AQM
	JX6+eM3UxcjBISIQLXHpWD1IDbPAUmaJ6Z23wCYJC0RIPHy6AKyeRUBVYvnqx2wgNq+Ah8T+
	RddZQXolBBQk5kyyATE5gcItv51ATCEBd4k3Vw0nMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1ya
	l66XnJ+7iREc5s+kdjCubLA4xCjAwajEw7tBbn2IEGtiWXFl7iFGCQ5mJRHehs1AId6UxMqq
	1KL8+KLSnNTiQ4zSHCxK4rxK9m0hQgLpiSWp2ampBalFMFkmDk6pBsY5W9L0n1xuM1634Iv5
	fCGlB2v+8y40y5jZdVvpZ43GKkZBWa87SubqC3f9V9ovET855OjGYrMDX3Vu3NaO4Zn8cN69
	pdf+Ff84xNcbyMu6ZcWVBhEtucfSp9zC776fWynwm/3r0XePQ+67Zc0QuegdLLddpKLwtaPI
	ozky7mt7lGwLOgw4zS4qsRRnJBpqMRcVJwIAKk0pQG8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a description of 'flashes' property
to the samsung-fimc.txt.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 922d6f8..22a6b2f 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -40,6 +40,12 @@ should be inactive. For the "active-a" state the camera port A must be activated
 and the port B deactivated and for the state "active-b" it should be the other
 way around.
 
+Optional properties:
+
+- flashes - Array of phandles to flash LED devices, or their sub-nodes
+	    representing sub-leds.
+	    (see Documentation/devicetree/bindings/leds/common.txt)
+
 The 'camera' node must include at least one 'fimc' child node.
 
 
@@ -166,6 +172,7 @@ Example:
 		clock-output-names = "cam_a_clkout", "cam_b_clkout";
 		pinctrl-names = "default";
 		pinctrl-0 = <&cam_port_a_clk_active>;
+		flashes = <&camera_flash>, <&system_torch>;
 		status = "okay";
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.9.5

