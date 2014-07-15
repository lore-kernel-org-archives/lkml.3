Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaGORDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:03:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44690 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbaGORCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:16 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 46/94] ARM: dts: am335x-evm: Enable the McASP FIFO for audio
Date: Tue, 15 Jul 2014 20:01:01 +0300
Message-Id: <1405443709-15288-46-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

The use of FIFO in McASP can reduce the risk of audio under/overrun and
lowers the load on the memories since the DMA will operate in bursts.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/boot/dts/am335x-evm.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index ecb2677..e2156a5 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -529,8 +529,8 @@
 		serial-dir = <  /* 0: INACTIVE, 1: TX, 2: RX */
 			0 0 1 2
 		>;
-		tx-num-evt = <1>;
-		rx-num-evt = <1>;
+		tx-num-evt = <32>;
+		rx-num-evt = <32>;
 };
 
 &tps {
-- 
1.7.10.4

