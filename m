Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3H1LNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:13:12 -0400
Received: from mo3.mail-out.ovh.net ([178.32.228.3]:33318 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3H1LNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:13:07 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH 0/9] ARM: at91/dt: add missing devices to rm9200ek board
Date: Wed, 28 Aug 2013 13:00:40 +0200
Message-Id: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 15590054536033433824
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds support for the remaining devices (or device options)
not yet supported in dt.

AFAICT there is no more infos/devices not converted to dt for this board,
and we should be able to remove board-at91rm9200ek.c (when we decide to
do it).

This series was not tested (the dt compilation passed), could someone
owning this board test it ?

In order to test it, you need to apply these series first:
https://lkml.org/lkml/2013/8/27/58
pinctrl: at91: add support for OUTPUT config

Best Regards,

Boris

Boris BREZILLON (9):
  ARM: at91/dt: rm9200: add spi0 chip select pins definitions
  ARM: at91/dt: add ethernet phy to at91rm9200ek board
  ARM: at91/dt: add usb1 vbus and pullup pins
  ARM: at91/dt: add atmel,pullup-gpio to at91rm9200ek usb1 definition
  ARM: at91/dt: add mmc0 slot0 support to at91rm9200ek board
  ARM: at91/dt: add spi0 support to at91rm9200ek board
  ARM: at91/dt: add i2c devices connected to at91rm9200ek board
  ARM: at91/dt: add new at91rm9200ek_mmc board
  ARM: at91/dt: add new at91rm9200ek_dataflash board

 arch/arm/boot/dts/at91rm9200.dtsi            |   20 ++++++
 arch/arm/boot/dts/at91rm9200ek.dts           |   88 ++++++++++++++++++++++++++
 arch/arm/boot/dts/at91rm9200ek_dataflash.dts |   33 ++++++++++
 arch/arm/boot/dts/at91rm9200ek_mmc.dts       |   23 +++++++
 4 files changed, 164 insertions(+)
 create mode 100644 arch/arm/boot/dts/at91rm9200ek_dataflash.dts
 create mode 100644 arch/arm/boot/dts/at91rm9200ek_mmc.dts

-- 
1.7.9.5

