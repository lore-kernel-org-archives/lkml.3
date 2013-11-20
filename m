Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3KTAWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:22:22 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38276 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3KTAWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:22:18 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 20 Nov 2013 09:22:59 +0900
Message-Id: <20131120002259.27342.35575.sendpatchset@w520>
Subject: [PATCH 00/05] gpio: R-Car and EM GPIO update V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio: R-Car and EM GPIO update V2

[PATCH 01/05 v2] gpio: rcar: Use lazy disable
[PATCH 02/05 v2] gpio: rcar: Enable mask on suspend
[PATCH 03/05] gpio: em: Setup gpiochip->dev
[PATCH 04/05 v2] gpio: em: Use lazy disable
[PATCH 05/05 v2] gpio: em: Enable mask on suspend

Update the R-Car GPIO driver and the GPIO driver used on EMEV2 to use lazy
disable and mask on suspend. This fixes the Suspend-to-RAM behavior to make
sure wakeup sources are left enabled while suspending. Also include a small
fix for gpio-em that fixes the DT use case.

Thanks to Laurent and Linus for feedback.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Written against renesas.git tag renesas-devel-v3.12-20131119

 Changes since V1:
 - Split lazy disable and mask on suspend patches
 - Improved commit messages

 drivers/gpio/gpio-em.c   |    5 ++---
 drivers/gpio/gpio-rcar.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

