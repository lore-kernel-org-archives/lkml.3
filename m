Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaK1JUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:20:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53315 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaK1JUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:20:12 -0500
X-AuditID: cbfee61a-f79c06d000004e71-7d-54783e4af91a
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH/RFC v8 08/14] DT: Add documentation for exynos4-is 'flashes'
 property
Date: Fri, 28 Nov 2014 10:18:00 +0100
Message-id: <1417166286-27685-9-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jQV0vu4oQg+Yf+hYbZ6xntTi6cyKT
	xfwj51gt+t8sZLU492olo0Xv1eeMFmeb3rBbXN41h81i65t1jBY9G7ayWiy9fpHJ4u6po2wW
	E6avZbFo3XuE3WL3rqesFofftLNanNm/ks1B0GPNvDWMHpf7epk8ds66y+6xcvkXNo/DXxey
	eGxa1cnmsWf+D1aPvi2rGD1WrP7O7vF5k1wAVxSXTUpqTmZZapG+XQJXxv+ue8wFn3kqrq/f
	xt7A+Iqri5GTQ0LARKKhbwYzhC0mceHeerYuRi4OIYHpjBIru7cwQzjtTBJnPqxlAaliEzCU
	+PniNVMXIweHiEC0xKVj9SA1zALLmSVefDnCBFIjLBAusb39JitIDYuAqsTH47EgYV4BD4mb
	PSvBWiUEFCTmTLIBCXMKeErM/QwynQNolYfEolcpExh5FzAyrGIUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIDvNnUjsYVzZYHGIU4GBU4uH98a88RIg1say4MvcQowQHs5II76mvQCHelMTK
	qtSi/Pii0pzU4kOM0hwsSuK8N27mhggJpCeWpGanphakFsFkmTg4pRoY2W880j9S0+7SbfTb
	MiFzwa8F6Uk+y9xua011m7r34abDx6s09ZnWFewRYc0Qv1FusfLWf2MHEXb1ne8s6zdLTCnx
	2rP6+XcN74i1q6eo7ii+frlV7+D/i59/Z2qmR/U3aq7Jyvt8/+m0vVFLlCWK/6/t1z55JPu5
	odtCht98D06JaE/psuP9rcRSnJFoqMVcVJwIABUi3MpvAgAA
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
Cc: <devicetree@vger.kernel.org>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 922d6f8..4b7ed03 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -40,6 +40,12 @@ should be inactive. For the "active-a" state the camera port A must be activated
 and the port B deactivated and for the state "active-b" it should be the other
 way around.
 
+Optional properties:
+
+- flashes - array of strings with flash led names; the name has to
+	    be same with the related led label
+	    (see Documentation/devicetree/bindings/leds/common.txt)
+
 The 'camera' node must include at least one 'fimc' child node.
 
 
@@ -166,6 +172,7 @@ Example:
 		clock-output-names = "cam_a_clkout", "cam_b_clkout";
 		pinctrl-names = "default";
 		pinctrl-0 = <&cam_port_a_clk_active>;
+		flashes = "max77693-flash1", "max77693-flash2";
 		status = "okay";
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.9.5

