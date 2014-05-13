Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbaEMIoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:44:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51129 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaEMIof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:44:35 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH 0/2] Add AM437x GP EVM cpsw DT node
Date: Tue, 13 May 2014 14:14:29 +0530
Message-ID: <1399970671-29203-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.9.2.459.g68773ac
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AM437x GP EVM cpsw device tree node

Mugunthan V N (2):
  ARM: dts: am4372: Add cpsw phy sel dt node
  ARM: dts: am437x-gp-evm: Add ethernet support for GP EVM

 arch/arm/boot/dts/am4372.dtsi       |  6 ++++
 arch/arm/boot/dts/am437x-gp-evm.dts | 72 +++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

-- 
1.9.2.459.g68773ac

