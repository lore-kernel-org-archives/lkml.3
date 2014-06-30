Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaF3NCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:02:19 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:62931 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaF3NCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:02:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH 0/5] phy: miphy365x: Introduce support for MiPHY365x
Date: Mon, 30 Jun 2014 14:01:52 +0100
Message-Id: <1404133317-25953-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

This submission is the same as the last one, only each channel is
now represented by its own sub-node.  The documentation has also
been updated accordingly.

Kind regards,
Lee

 .../devicetree/bindings/phy/phy-miphy365x.txt      |  76 +++
 arch/arm/boot/dts/stih416-b2020-revE.dts           |   5 +
 arch/arm/boot/dts/stih416-b2020.dts                |   7 +
 arch/arm/boot/dts/stih416.dtsi                     |  21 +
 drivers/phy/Kconfig                                |  10 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-miphy365x.c                        | 676 +++++++++++++++++++++
 include/dt-bindings/phy/phy-miphy365x.h            |  25 +
 8 files changed, 821 insertions(+)

