Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaJAVb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:31:28 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52883 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaJAVb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:31:26 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, Carlo Caione <carlo@caione.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 0/6] ARM: add machine and dts files for Amlogic Meson8
Date: Wed,  1 Oct 2014 23:29:40 +0200
Message-Id: <1412198986-26534-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset introduces a machine definition and dts files for
Amlogic Meson8, which is a family of quad-core Cortex-A9 SoCs used in
tablets and set-top boxes.

Beniamino Galvani (6):
  ARM: meson: add meson8 machine definition
  ARM: dts: add dtsi for Amlogic Meson8 SoCs
  ARM: dts: add dts for Tronsmart S89 Elite TV box
  of: add vendor prefix for Tronsmart
  ARM: document Tronsmart compatible properties
  ARM: meson: document meson8 compatible properties

 Documentation/devicetree/bindings/arm/amlogic.txt  |  8 +-
 .../devicetree/bindings/arm/tronsmart.txt          |  7 ++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/boot/dts/meson8-vega-s89e.dts             | 65 ++++++++++++++++
 arch/arm/boot/dts/meson8.dtsi                      | 90 ++++++++++++++++++++++
 arch/arm/mach-meson/Kconfig                        |  5 ++
 arch/arm/mach-meson/meson.c                        |  8 ++
 7 files changed, 181 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/tronsmart.txt
 create mode 100644 arch/arm/boot/dts/meson8-vega-s89e.dts
 create mode 100644 arch/arm/boot/dts/meson8.dtsi

-- 
1.9.1

