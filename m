Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaLWMqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:46:55 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49880 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbaLWMqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:46:45 -0500
X-AuditID: cbfee68e-f79b46d000002b74-57-5499642f2fa4
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 4/4] ARM: dts: Enable USB node for exynos3250-monk
Date: Tue, 23 Dec 2014 21:46:32 +0900
Message-id: <1419338792-22853-5-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1419338792-22853-1-git-send-email-jaewon02.kim@samsung.com>
References: <1419338792-22853-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkSFc/ZWaIwY2dkhbXvzxntdjRcITV
	ov/xa2aLy7vmsFnMOL+PyWLRslZmBzaPTas62Tz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr
	Y+vN7UwF+1grZp4+wNTAuJ+li5GTQ0LAROJZ21pWCFtM4sK99WxdjFwcQgJLGSV2NV+CK1r3
	9yIrRGI6o8TnY9ugnDYmiV+rL4NVsQloS3xfvxgowcEhIqAosXmBAkgNs8B6RokdG26xgdQI
	CzhJvP94gx3EZhFQlTi9uxcszivgIbHz9w42kF4JAQWJOZNsQExOAU+JhTv1QCqEgCo2LZnE
	DjJSQqCdXeL3zp3MEGMEJL5NPsQC0SorsekAM8TNkhIHV9xgmcAovICRYRWjaGpBckFxUnqR
	kV5xYm5xaV66XnJ+7iZGYBif/vesbwfjzQPWhxgFOBiVeHh/npsRIsSaWFZcmXuI0RRow0Rm
	KdHkfGC05JXEGxqbGVmYmpgaG5lbmimJ8yZI/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wChQz/hs6jff76cUhDby3xFlm1RmfH35l87kLcazeVpUGQ0EJ1xcOqdfZJvZk2jT49URe+tX
	HhZ+9ORf1XXR7s07ZVM1DCN/OnPpTTH8YLtHXY0lvd1Ctjdk5cp5l2Jzvh+85b7qi88p/W7h
	6Dc6IjNm1p9/+Drwad4ym9r78Zw7RR8u4V9u8F6JpTgj0VCLuag4EQBr5YC/XgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQV39lJkhBnc2CFlc//Kc1WJHwxFW
	i/7Hr5ktLu+aw2Yx4/w+JotFy1qZHdg8Nq3qZPPo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMVKCmWJOaVAoYDE4mIlfTtM
	E0JD3HQtYBojdH1DguB6jAzQQMIaxoytN7czFexjrZh5+gBTA+N+li5GTg4JAROJdX8vskLY
	YhIX7q1n62Lk4hASmM4o8fnYNlYIp41J4tfqy2AdbALaEt/XLwZKcHCICChKbF6gAFLDLLCe
	UWLHhltsIDXCAk4S7z/eYAexWQRUJU7v7gWL8wp4SOz8vYMNpFdCQEFiziQbEJNTwFNi4U49
	kAohoIpNSyaxT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOEqeSe9gXNVgcYhR
	gINRiYd3wZkZIUKsiWXFlbmHGCU4mJVEeJUDZ4YI8aYkVlalFuXHF5XmpBYfYjQFumkis5Ro
	cj4wgvNK4g2NTcyMLI3MDS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqYODilGhjblk1+v1Sw
	5dStze5KZYFruc0nOpYuWax+dXeFYti7E/83nhX2Ci3Y8n9mZcJHjaz4GdUZuRs8tvOaXs1c
	ah0qzRktxqXHsuO9Dc+3lKKN2gbGwfOYHuTrqgRPvVy0a1rW8e0qJxITt4gcn8eXoP9v/tGU
	fqeDYYusVp/32ct46viqp0/DjucosRRnJBpqMRcVJwIA1uyxqagCAAA=
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

