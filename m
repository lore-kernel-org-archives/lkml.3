Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab3CVOXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:23:41 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:56892 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928Ab3CVOXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:23:39 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/4] ARM: at91: little DT fixes
Date: Fri, 22 Mar 2013 15:23:32 +0100
Message-ID: <cover.1363960549.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are some little fixes found while adding device tree boards.
I plan to request a pull on this material early next week.


Nicolas Ferre (4):
  ARM: at91/dt: fix macb node declaration
  ARM: at91/trivial: typos in compatible property
  ARM: at91/trivial: fix model name for SAM9G15-EK
  ARM: at91: remove partial parameter in bootargs for at91sam9x5ek.dtsi

 arch/arm/boot/dts/at91sam9g15.dtsi  |  2 +-
 arch/arm/boot/dts/at91sam9g15ek.dts |  2 +-
 arch/arm/boot/dts/at91sam9g25.dtsi  |  2 +-
 arch/arm/boot/dts/at91sam9g25ek.dts |  9 +++++++++
 arch/arm/boot/dts/at91sam9g35.dtsi  |  2 +-
 arch/arm/boot/dts/at91sam9g35ek.dts |  9 +++++++++
 arch/arm/boot/dts/at91sam9x25.dtsi  |  2 +-
 arch/arm/boot/dts/at91sam9x25ek.dts | 14 ++++++++++++++
 arch/arm/boot/dts/at91sam9x35.dtsi  |  2 +-
 arch/arm/boot/dts/at91sam9x35ek.dts |  9 +++++++++
 arch/arm/boot/dts/at91sam9x5ek.dtsi |  7 +------
 11 files changed, 48 insertions(+), 12 deletions(-)

-- 
1.8.0

