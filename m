Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab3C1QV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:21:29 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50968 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab3C1QV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:21:26 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/2] pinctrl support for ab8500-usb
Date: Thu, 28 Mar 2013 17:21:07 +0100
Message-Id: <1364487669-24368-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this contains the required definitions for ab8500-usb pinctrl sleep and
default modes, and a non-related patch to drop a macro redefinition.

Thanks,
Fabio

Fabio Baltieri (1):
  ARM: ux500: remove redundant DB8500_PIN_SLEEP definition

Patrice Chotard (1):
  ARM: ux500: 8500: add ab8500-musb pinctrl support

 arch/arm/mach-ux500/board-mop500-pins.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

-- 
1.8.1.3

