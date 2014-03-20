Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163AbaCTOwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:52:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29205 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004AbaCTOwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:52:03 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-7a-532b00929675
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC 8/8] DT: Add documentation for exynos4-is camera-flash
 property
Date: Thu, 20 Mar 2014 15:51:10 +0100
Message-id: <1395327070-20215-9-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQd1JDNrBBtPOqFncWneO1WL+ESDR
	/2Yhq8W5VysZLXqvPme0ONv0ht3i8q45bBZb36xjtOjZsJXVYun1i0wWE6avZbFo3XuE3eLw
	m3ZWB16PNfPWMHpc7utl8li5/Aubx6ZVnWwefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlfFj
	dUDBSa6KBRtcGxhfc3QxcnJICJhI7Lz9kxHCFpO4cG89WxcjF4eQwHRGiX8Tn7FDOJ1MEmt6
	X4NVsQkYSvx88ZoJxBYRKJeYNvURE0gRs8A2JolNzd9Yuhg5OIQFQiVOrjQGqWERUJXoX7yR
	FcTmFfCQWHvmCBNIiYSAgsScSTYgYU4BT4mlS7uYQcJCQCVnJ0ZMYORdwMiwilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4KJ9J7WBc2WBxiFGAg1GJh3fFHs1gIdbEsuLK3EOMEhzMSiK8
	ds+1goV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwrvCa
	HbHv8D2r6pLVs6+ZH9M2XT7hZe7KE/MvL895Oqv7062e5AMbfadx5DkcNPerWrXjwqx4ZU/z
	BBX1GS3d1wtn9bwxsvkTKj4rNX3bvVPrNy4+c83wh1fwDwlLC9NzYf12MpM2BIVHXeLYnq65
	ZtElI3/eg/sKNjxMf3T3+FbxrxNuiZpd36TEUpyRaKjFXFScCADsN9NLRgIAAA==
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

