Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3LQCg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:36:56 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44849 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3LQCgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:36:54 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, linus.walleij@linaro.org, linux-sh@vger.kernel.org,
        horms@verge.net.au, laurent.pinchart@ideasonboard.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 17 Dec 2013 11:37:45 +0900
Message-Id: <20131217023745.24573.3660.sendpatchset@w520>
Subject: [PATCH 00/05 v2] pinctrl: sh-pfc: r7s72100 support V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinctrl: sh-pfc: r7s72100 support V2

[PATCH 01/05 v2] pinctrl: sh-pfc: Rework _GP_GPIO, introduce _GP_GPIO32
[PATCH 02/05 v2] pinctrl: sh-pfc: r7s72100 base support
[PATCH 03/05 v2] pinctrl: sh-pfc: r7s72100 single pin macros
[PATCH 04/05 v2] pinctrl: sh-pfc: r7s72100 SCIF support
[PATCH 05/05 v2] pinctrl: sh-pfc: r8a7791 and r7s72100 binding docs

This is V2 of r7s72100 PFC support. Included this time is:
- Some slight rework of shared sh-pfc macros
- Complete r7s72100 SCIF support
- Binding documentation

If you prefer me to adjust this code somehow then please let me know.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Written against renesas.git tag renesas-devel-v3.13-rc3-20131214v2

 Documentation/devicetree/bindings/pinctrl/renesas,pfc-pinctrl.txt |    2 
 drivers/pinctrl/sh-pfc/Kconfig                                    |    5 
 drivers/pinctrl/sh-pfc/Makefile                                   |    1 
 drivers/pinctrl/sh-pfc/core.c                                     |    9 
 drivers/pinctrl/sh-pfc/core.h                                     |    1 
 drivers/pinctrl/sh-pfc/pfc-r7s72100.c                             |  340 ++++++++++
 drivers/pinctrl/sh-pfc/sh_pfc.h                                   |    9 
 7 files changed, 363 insertions(+), 4 deletions(-)
