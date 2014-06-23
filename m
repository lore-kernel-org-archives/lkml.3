Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaFWSVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:21:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53409 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaFWSVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:21:39 -0400
From: Felipe Balbi <balbi@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
CC: <robh+dt@kernel.org>, <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Nishanth Menon <nm@ti.com>,
        <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 0/2] arm: dts: add support for am437x sk
Date: Mon, 23 Jun 2014 13:20:57 -0500
Message-ID: <1403547659-24558-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here's v3 of am437x sk support. Patches tested on top of next-20140617.

Note that this series was tested with the following extra patches:

http://marc.info/?l=linux-omap&m=140299431732700&w=2
http://marc.info/?l=linux-omap&m=140300146503126&w=2
http://marc.info/?l=linux-omap&m=140299231232123
http://marc.info/?l=linux-omap&m=140310472709968&w=2
http://marc.info/?l=linux-omap&m=140310471409959&w=2

A branch is also available with all these patches at [1].

[1] http://git.kernel.org/cgit/linux/kernel/git/balbi/usb.git/log/?h=am437x-starterkit

Felipe Balbi (2):
  arm: dts: am4372: let boards access all nodes through phandles
  arm: dts: add support for AM437x StarterKit

 .../devicetree/bindings/arm/omap/omap.txt          |   3 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/am4372.dtsi                      |   8 +-
 arch/arm/boot/dts/am437x-sk-evm.dts                | 613 +++++++++++++++++++++
 4 files changed, 621 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/boot/dts/am437x-sk-evm.dts

-- 
2.0.0.390.gcb682f8

