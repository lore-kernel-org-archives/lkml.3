Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaFZKNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:13:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42702 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750755AbaFZKNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:13:40 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/2] ARM: at91: remove phy fixup for sama5d3xek boards
Date: Thu, 26 Jun 2014 12:13:33 +0200
Message-Id: <1403777615-25685-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch removes a board specific hook for sama5d3xek boards from the
sama5d3 generic DT board file.

This hook (which register a phy fixup configuring board specific delays
in the ksz9021 ethernet phy) is now replaced by the appropriate DT
properties definitions in the sama5d3xcm.dtsi file.

Best Regards,

Boris

Changes since v1:
 - fix txc-skew-ps and rxc-skew-ps delays
 - remove phy address info to handle Ronetix and Embest HW designs

Boris BREZILLON (2):
  ARM: at91/dt: describe rgmii ethernet phy connected to sama5d3xek
    boards
  ARM: at91: remove phy fixup for sama5d3xek boards

 arch/arm/boot/dts/sama5d3xcm.dtsi   | 15 +++++++++++++++
 arch/arm/mach-at91/board-dt-sama5.c | 22 ----------------------
 2 files changed, 15 insertions(+), 22 deletions(-)

-- 
1.8.3.2

