Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbaLMBrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 20:47:06 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33639 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934AbaLMBrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 20:47:03 -0500
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/3] removing of some unused/unsupported dts entries
Date: Sat, 13 Dec 2014 02:46:45 +0100
Message-Id: <cover.1418434448.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have found some dts entries which are not evaluated by the drivers. This
patch remove this entries from the dts files.
Jason has mentioned I should CC: Thomas, Marc and him self to this mails.

thanks and best regards,
Silvio


Silvio Fricke (3):
  ARM: mx5: dts: remove unused irq-trigger entry
  ARM: tegra: dts: remove unused irq-trigger entry
  ARM: SPEAr: dts: remove unused irq-trigger, id and block entries

 arch/arm/boot/dts/imx53-m53.dtsi      | 1 -
 arch/arm/boot/dts/spear1310-evb.dts   | 1 -
 arch/arm/boot/dts/spear1340-evb.dts   | 2 --
 arch/arm/boot/dts/spear320-hmi.dts    | 3 ---
 arch/arm/boot/dts/tegra30-apalis.dtsi | 1 -
 5 files changed, 8 deletions(-)

-- 
2.1.3

