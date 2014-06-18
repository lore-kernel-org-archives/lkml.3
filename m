Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaFRPn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:43:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56149 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaFRPnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:43:55 -0400
From: Felipe Balbi <balbi@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
CC: <robh+dt@kernel.org>, <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Nishanth Menon <nm@ti.com>,
        <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 0/2] arm: dts: add support for am437x sk
Date: Wed, 18 Jun 2014 10:43:18 -0500
Message-ID: <1403106200-777-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.0.rc1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here's v2 of am437x sk support. Patches tested on top of next-20140617.

Note that this series was tested with the following extra patches:

http://marc.info/?l=linux-omap&m=140299431732700&w=2
http://marc.info/?l=linux-omap&m=140300146503126&w=2
http://marc.info/?l=linux-omap&m=140299231232123
http://marc.info/?l=linux-omap&m=140310472709968&w=2
http://marc.info/?l=linux-omap&m=140310471409959&w=2

A branch is also available with all these patches at [1] and serial console
capture is available at [2].

[1] http://git.kernel.org/cgit/linux/kernel/git/balbi/usb.git/log/?h=am437x-starterkit
[2] http://slexy.org/view/s20wyUDXDh

Felipe Balbi (2):
  arm: dts: am4372: let boards enable RTC and Watchdog
  arm: dts: add support for AM437x StarterKit

 .../devicetree/bindings/arm/omap/omap.txt          |   3 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/am4372.dtsi                      |   4 +-
 arch/arm/boot/dts/am437x-sk-evm.dts                | 583 +++++++++++++++++++++
 4 files changed, 589 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/boot/dts/am437x-sk-evm.dts

-- 
2.0.0.rc1

