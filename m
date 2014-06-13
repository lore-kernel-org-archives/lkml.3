Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaFMNnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:43:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45941 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750886AbaFMNnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:43:33 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/3] ARM: at91/dt: clock fixes
Date: Fri, 13 Jun 2014 15:43:18 +0200
Message-Id: <1402667001-11207-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some clocks were not properly defined:
 - ICPLL and OUT values for PLLA got mixed on sam9x5 and sam9n12
 - mainck was not correctly defined on sam9261

Alexandre Belloni (3):
  ARM: at91/dt: sam9x5: correct PLLA ICPLL and OUT values
  ARM: at91/dt: sam9n12: correct PLLA ICPLL and OUT values
  ARM: at91/dt: sam9261: correctly define mainck

 arch/arm/boot/dts/at91sam9261.dtsi | 10 ++++++++--
 arch/arm/boot/dts/at91sam9n12.dtsi |  4 ++--
 arch/arm/boot/dts/at91sam9x5.dtsi  |  4 ++--
 3 files changed, 12 insertions(+), 6 deletions(-)

-- 
1.9.1

