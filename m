Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaC1P35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:29:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40190 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaC1P3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:29:54 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-01-533595710193
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v2 8/8] DT: Add documentation for exynos4-is camera-flash
 property
Date: Fri, 28 Mar 2014 16:29:05 +0100
Message-id: <1396020545-15727-9-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
References: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd3CqabBBnd3iFjcWneO1WL+ESDR
	/2Yhq8W5VysZLXqvPme0ONv0ht3i8q45bBZb36xjtOjZsJXVYun1i0wWE6avZbFo3XuE3eLw
	m3ZWB16PNfPWMHpc7utl8li5/Aubx6ZVnWwefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlfFj
	dUDBSa6KBRtcGxhfc3QxcnJICJhInH5wjhHCFpO4cG89WxcjF4eQwHRGievtX1ghnE4miaeL
	TrGDVLEJGEr8fPGaCcQWESiXmDb1ERNIEbPANiaJTc3fWEASwgIREieetjKD2CwCqhJPv60E
	inNw8Ap4SKy+bAdiSggoSMyZZANSwSngKXH7RTvYEUJAFV/mnGSfwMi7gJFhFaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZwWD6T3sG4qsHiEKMAB6MSD69Aq2mwEGtiWXFl7iFGCQ5mJRHe
	rIlAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYyNurvP
	LHwx/R/DpMmND7rWBautv7v9ofCDDTf0lj2+xtQXIvtwUgSjFnPQweTLpkceq4c2Gjyunbtr
	MbfB6xulS7m8zm6oKGdXSpG4WyR/w2BltMd35gfn3p32zuRJ2pIs6KiZ+SZu4dGzAlz3z3Fz
	WE85zlTRw3B13UL1njwnm9rlr86plkoqsRRnJBpqMRcVJwIAehn2cUcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 922d6f8..88f9287 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -108,6 +108,8 @@ Image sensor nodes
 The sensor device nodes should be added to their control bus controller (e.g.
 I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
 using the common video interfaces bindings, defined in video-interfaces.txt.
+If the sensor device has a led flash device associated with it then its phandle
+should be assigned to the camera-flash property.
 
 Example:
 
@@ -125,6 +127,7 @@ Example:
 			clock-frequency = <24000000>;
 			clocks = <&camera 1>;
 			clock-names = "mclk";
+			camera-flash = <&led_flash>;
 
 			port {
 				s5k6aa_ep: endpoint {
-- 
1.7.9.5

