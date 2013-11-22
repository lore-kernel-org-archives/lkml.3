Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3KVB56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:57:58 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49191 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3KVB5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:57:43 -0500
From: Joel Fernandes <joelf@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <benoit.cousson@linaro.org>, <santosh.shilimkar@ti.com>,
        <jgchunter@gmail.com>, <rnayak@ti.com>, <balbi@ti.com>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 7/8] ARM: DTS: am33xx: Provide the ti,timer-parent property
Date: Thu, 21 Nov 2013 19:56:53 -0600
Message-ID: <1385085414-9034-8-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385085414-9034-1-git-send-email-joelf@ti.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the clock alias of the parent clock for the system timer, using the
just added ti,timer-parent property.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index f9c5da9..3934630 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -259,6 +259,7 @@
 			interrupts = <67>;
 			ti,hwmods = "timer1";
 			ti,timer-alwon;
+			ti,timer-parent = "timer_sys_ck";
 		};
 
 		timer2: timer@48040000 {
@@ -266,6 +267,7 @@
 			reg = <0x48040000 0x400>;
 			interrupts = <68>;
 			ti,hwmods = "timer2";
+			ti,timer-parent = "timer_sys_ck";
 		};
 
 		timer3: timer@48042000 {
-- 
1.8.1.2

