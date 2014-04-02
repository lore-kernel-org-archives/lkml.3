Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbaDBRF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:05:58 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:32987 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700AbaDBRFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:05:48 -0400
From: stefan@agner.ch
To: shawn.guo@freescale.com, kernel@pengutronix.de, viresh.linux@gmail.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH v2 0/2] ARM: dts: fix wrong stmpe-ts bindings
Date: Wed,  2 Apr 2014 19:05:36 +0200
Message-Id: <cover.1396457876.git.stefan@agner.ch>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

I don't have any of these hardware, but the error is obvious. The device
probably works anyway since the device/driver will use default values.

Changes since v1:
- Split patch in two for i.MX/SPEAr

Stefan Agner (2):
  ARM: dts: mx5: fix wrong stmpe-ts bindings
  ARM: dts: SPEAr: fix wrong stmpe-ts bindings

 arch/arm/boot/dts/imx53-m53evk.dts  | 20 ++++++++++----------
 arch/arm/boot/dts/spear1310-evb.dts | 18 +++++++++---------
 arch/arm/boot/dts/spear1340-evb.dts | 18 +++++++++---------
 arch/arm/boot/dts/spear320-hmi.dts  | 20 ++++++++++----------
 4 files changed, 38 insertions(+), 38 deletions(-)

-- 
1.9.1

