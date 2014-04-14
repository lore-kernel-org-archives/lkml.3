Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaDNTNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:13:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58064 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaDNTNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:13:11 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] ARM: dts: DRA7/AM4372: add l3_noc information
Date: Mon, 14 Apr 2014 14:12:44 -0500
Message-ID: <1397502766-13994-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch series based on:
v3.15-rc1 tag.

Depends on series posted: http://marc.info/?l=linux-omap&m=139749383932575&w=2

DTS Patches is available here:
https://github.com/nmenon/linux-2.6-playground/commits/l3noc/dts-fixes

This just adds the dts information based on driver support provided.

Test log:
1: am43xx-epos:  Boot PASS: http://slexy.org/raw/s2pjavFUYd
2: DRA7xx-EVM:  Boot PASS: http://slexy.org/raw/s21pdAj0hU
3: pandaboard-es:  Boot PASS: http://slexy.org/raw/s21Hsq97mt
4:    sdp4430:  Boot PASS: http://slexy.org/raw/s2ZQJUqjrP
5: OMAP5432uEVM:  Boot PASS: http://slexy.org/raw/s2hNulLOuX

Afzal Mohammed (1):
  ARM: dts: AM4372: add l3-noc information

Rajendra Nayak (1):
  ARM: dts: DRA7: Use dra7-l3-noc instead of omap4-l3-noc

 arch/arm/boot/dts/am4372.dtsi |    6 +++++-
 arch/arm/boot/dts/dra7.dtsi   |    6 +++---
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
1.7.9.5

