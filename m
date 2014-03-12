Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaCLNPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:15:22 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58639 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaCLNPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:15:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, alexandre.torgue@st.com
Subject: [PATCH 0/4] phy: Introduce support for MiPHY365x
Date: Wed, 12 Mar 2014 13:14:52 +0000
Message-Id: <1394630096-28564-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

Sorry for the delay, the last couple of weeks have been pretty hectic.
Here is the MiPHY365x patchset complete with all the DT Acks applied.

Kind regards,
Lee

 Documentation/devicetree/bindings/phy/phy-miphy365x.txt |  62 +++++++++++
 arch/arm/boot/dts/stih416-b2020-revE.dts                |   6 +-
 arch/arm/boot/dts/stih416-b2020.dts                     |   6 ++
 arch/arm/boot/dts/stih416.dtsi                          |  14 +++
 drivers/phy/Kconfig                                     |  10 ++
 drivers/phy/Makefile                                    |   1 +
 drivers/phy/phy-miphy365x.c                             | 630 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/dt-bindings/phy/phy-miphy365x.h                 |  25 +++++
 8 files changed, 753 insertions(+), 1 deletion(-)

