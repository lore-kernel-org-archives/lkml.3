Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaHaLWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:22:30 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:58954 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbaHaLW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:22:29 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] pinctrl: at91: Fixes in probe function
Date: Sun, 31 Aug 2014 16:51:51 +0530
Message-Id: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset modifies the probe function to do some changes such as 
switching to manage version of clk_get, fixing the error path by releasing
resources etc. The last patch adds a remove function for clean unload.

Pramod Gurav (4):
  pinctrl: at91: Switch to using managed clk_get
  pinctrl: at91: Fix failure path in at91_gpio_probe path
  pinctrl: at91: Fix error handling while doing gpiochio_irqchip_add
  pinctrl: at91: Add remove function in platform_driver
    at91_gpio_driver

 drivers/pinctrl/pinctrl-at91.c |   51 +++++++++++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 14 deletions(-)

