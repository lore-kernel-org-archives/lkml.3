Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaEVNxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:53:53 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33047 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaEVNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:53:52 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Subject: [RESEND 0/4] phy: Introduce support for MiPHY365x
Date: Thu, 22 May 2014 14:53:35 +0100
Message-Id: <1400766819-22286-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

As requested, please find the patches to be applied to your v3.16
pull-request.

Kind regards,
Lee

 Documentation/devicetree/bindings/phy/phy-miphy365x.txt |  62 +++++++++++
 arch/arm/boot/dts/stih416-b2020-revE.dts                |   6 +-
 arch/arm/boot/dts/stih416-b2020.dts                     |   6 ++
 arch/arm/boot/dts/stih416.dtsi                          |  14 +++
 drivers/phy/Kconfig                                     |  10 ++
 drivers/phy/Makefile                                    |   1 +
 drivers/phy/phy-miphy365x.c                             | 630 ++++++++++++++++++++++
 include/dt-bindings/phy/phy-miphy365x.h                 |  25 +++++
 8 files changed, 753 insertions(+), 1 deletion(-)

