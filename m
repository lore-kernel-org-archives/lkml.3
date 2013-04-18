Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab3DRNBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:01:17 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:4267 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab3DRNBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:01:16 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <dgilbert@interlog.com>, <robertcnelson@gmail.com>,
        <tanzilli@acmesystems.it>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/5] ARM: at91: some more DT enhancements
Date: Thu, 18 Apr 2013 15:01:08 +0200
Message-ID: <cover.1366289869.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addition of the Acme systems Fox G20 board and some additions to the
at91sam9x5 DT and Aria board.

Douglas Gilbert (1):
  ARM: at91: add Acme Systems Fox G20 board

Nicolas Ferre (4):
  ARM: at91: at91sam9x5 RTC is not compatible with at91rm9200 one
  ARM: at91/at91-ariag25.dts: add RTC node
  ARM: at91/at91sam9x5.dtsi: add UART0/1 nodes
  ARM: at91/at91-ariag25.dts: UART0/1 nodes are disabled

 arch/arm/boot/dts/Makefile         |   1 +
 arch/arm/boot/dts/at91-ariag25.dts |  21 +++--
 arch/arm/boot/dts/at91-foxg20.dts  | 166 +++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  |  20 ++++-
 4 files changed, 201 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91-foxg20.dts

-- 
1.8.0

