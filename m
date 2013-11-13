Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab3KMW64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:58:56 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59105 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3KMW6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:58:48 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 14 Nov 2013 07:59:27 +0900
Message-Id: <20131113225927.21449.78044.sendpatchset@w520>
Subject: [PATCH 00/03] gpio: R-Car and EM GPIO update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio: R-Car and EM GPIO update

[PATCH 01/03] gpio: rcar: Use lazy disable and mask on suspend
[PATCH 02/03] gpio: em: Setup gpiochip->dev
[PATCH 03/03] gpio: em: Use lazy disable and mask on suspend

Update the R-Car GPIO driver and the GPIO driver used on EMEV2 to use lazy
disable and mask on suspend. This fixes the Suspend-to-RAM behavior to make
sure wakeup sources are left enabled while suspending. Also include a small
fix for gpio-em that fixes the DT use case.
 
Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Written against renesas.git tag renesas-devel-v3.12-20131112

 drivers/gpio/gpio-em.c   |    5 ++---
 drivers/gpio/gpio-rcar.c |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)
