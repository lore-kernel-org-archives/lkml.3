Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965676AbaFQQl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:41:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48050 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964930AbaFQQly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:41:54 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/6] ARM: at91: more clocks fixes for 3.16
Date: Tue, 17 Jun 2014 18:41:42 +0200
Message-Id: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set fixes more issues with the clocks on AT91:

The first patch define the slow crystal on the at91sam9261ek board

The next patchs are moving all the clocks that were under the root under a
"clocks" node to be consistent accross all architecture.

Alexandre Belloni (6):
  ARM: at91/dt: define sam9261ek slow crystal frequency
  ARM: at91/dt: sam9261 crystals under the clocks node
  ARM: at91/dt: sam9n12 crystals under the clocks node
  ARM: at91/dt: sam9rl crystals under the clocks node
  ARM: at91/dt: sam9x5 crystals under the clocks node
  ARM: at91/dt: sama5d3 crystals under the clocks node

 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 12 +++++++-----
 arch/arm/boot/dts/at91sam9261.dtsi          | 20 ++++++++++---------
 arch/arm/boot/dts/at91sam9261ek.dts         | 12 ++++++++----
 arch/arm/boot/dts/at91sam9n12.dtsi          | 20 ++++++++++---------
 arch/arm/boot/dts/at91sam9n12ek.dts         | 16 +++++++--------
 arch/arm/boot/dts/at91sam9rl.dtsi           | 22 ++++++++++-----------
 arch/arm/boot/dts/at91sam9rlek.dts          | 17 ++++++++--------
 arch/arm/boot/dts/at91sam9x5.dtsi           | 30 +++++++++++++++--------------
 arch/arm/boot/dts/at91sam9x5cm.dtsi         | 12 +++++++-----
 arch/arm/boot/dts/sama5d3.dtsi              | 22 ++++++++++-----------
 arch/arm/boot/dts/sama5d3xcm.dtsi           | 12 +++++++-----
 11 files changed, 105 insertions(+), 90 deletions(-)

-- 
1.9.1

