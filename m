Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab3IYBSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:18:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3IYAQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [ 012/110] ARM: dts: sunxi: cpus/cpu nodes dts updates
Date: Tue, 24 Sep 2013 17:14:10 -0700
Message-Id: <20130925001324.737050488@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

commit 14c44aa541744d4cf06db89c27a1e6df293c64d5 upstream.

This patch updates the in-kernel dts files according to the latest cpus
and cpu bindings updates for ARM.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sun4i-a10.dtsi |    2 ++
 arch/arm/boot/dts/sun5i-a13.dtsi |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -17,7 +17,9 @@
 
 	cpus {
 		cpu@0 {
+			device_type = "cpu";
 			compatible = "arm,cortex-a8";
+			reg = <0x0>;
 		};
 	};
 
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -18,7 +18,9 @@
 
 	cpus {
 		cpu@0 {
+			device_type = "cpu";
 			compatible = "arm,cortex-a8";
+			reg = <0x0>;
 		};
 	};
 


