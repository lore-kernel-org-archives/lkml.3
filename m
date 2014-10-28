Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbaJ1Gob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:44:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbaJ1Dtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:49:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Dueck <davidcdueck@googlemail.com>,
        Anthony Harivel <anthony.harivel@emtrion.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3.14 064/100] ARM: at91/dt: Fix typo regarding can0_clk
Date: Tue, 28 Oct 2014 11:35:49 +0800
Message-Id: <20141028033503.469804185@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Dueck <davidcdueck@googlemail.com>

commit 0a51d644c20f5c88fd3a659119d1903f74927082 upstream.

Otherwise the clock for can0 will never get enabled.

Signed-off-by: David Dueck <davidcdueck@googlemail.com>
Signed-off-by: Anthony Harivel <anthony.harivel@emtrion.de>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sama5d3_can.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/sama5d3_can.dtsi
+++ b/arch/arm/boot/dts/sama5d3_can.dtsi
@@ -40,7 +40,7 @@
 						atmel,clk-output-range = <0 66000000>;
 					};
 
-					can1_clk: can0_clk {
+					can1_clk: can1_clk {
 						#clock-cells = <0>;
 						reg = <41>;
 						atmel,clk-output-range = <0 66000000>;


