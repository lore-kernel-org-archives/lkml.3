Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab3JETFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 15:05:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45517 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab3JETFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 15:05:06 -0400
From: Joel Fernandes <joelf@ti.com>
To: Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH v3 0/3] AM33XX crypto DTS patches
Date: Sat, 5 Oct 2013 14:04:34 -0500
Message-ID: <1380999877-20884-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are some minor fixups and changes to commit messages to the
AM33XX crypto (aes, sham) patches with reference to the comments at:
http://comments.gmane.org/gmane.linux.drivers.devicetree/45961

Joel Fernandes (1):
  ARM: dts: AM33XX: Fix AES interrupt number

Mark A. Greer (2):
  ARM: dts: AM33XX: Add SHAM data and documentation
  ARM: dts: AM33XX: Add AES data and documentation

 .../devicetree/bindings/crypto/omap-aes.txt        | 31 ++++++++++++++++++++++
 .../devicetree/bindings/crypto/omap-sham.txt       | 28 +++++++++++++++++++
 arch/arm/boot/dts/am335x-bone.dts                  |  8 ++++++
 arch/arm/boot/dts/am335x-evm.dts                   |  8 ++++++
 arch/arm/boot/dts/am335x-evmsk.dts                 |  8 ++++++
 arch/arm/boot/dts/am33xx.dtsi                      | 19 +++++++++++++
 6 files changed, 102 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/omap-sham.txt

-- 
1.8.1.2

