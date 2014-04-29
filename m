Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaD2HVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:21:51 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37461 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaD2HVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:21:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH 0/4] phy: Introduce support for MiPHY365x
Date: Tue, 29 Apr 2014 08:21:30 +0100
Message-Id: <1398756095-32542-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

Here is the MiPHY365x patchset complete with all the DT Acks applied.

This set has been on the list for ~10 weeks now with no further comments.

Would you be kind enough to merge the PHY patches/documentation please?

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

