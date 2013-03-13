Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3CML0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:26:14 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:38342 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab3CML0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:26:13 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 13 Mar 2013 20:32:03 +0900
Message-Id: <20130313113203.30133.49539.sendpatchset@w520>
Subject: [PATCH 00/03] gpio: Renesas R-Car GPIO driver update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio: Renesas R-Car GPIO driver update

[PATCH 01/03] gpio: Renesas R-Car GPIO driver V2
[PATCH 02/03] gpio: rcar: Use IRQCHIP_SET_TYPE_MASKED
[PATCH 03/03] gpio: rcar: Make use of devm functions

This series updates the R-Car GPIO driver with various
changes kindly suggested by Laurent Pinchart.

Patch [01/03] is a drop in replacement for V1 of the R-Car
GPIO driver. The flag in patch [02/03] is kept out of [01/03]
to avoid changing the behaviour of the driver between V1 and V2.
Also, devm support in [03/03] is kept out of [01/03] to make
sure back porting goes as smooth as possible.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/Kconfig                    |    6 
 drivers/gpio/Makefile                   |    1 
 drivers/gpio/gpio-rcar.c                |  417 +++++++++++++++++++++++++++++--
 include/linux/platform_data/gpio-rcar.h |   25 +
 4 files changed, 427 insertions(+), 22 deletions(-)
