Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3G2SiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:38:16 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:32850 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab3G2SiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:38:12 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 0/3] pcf857x: Add OF support
Date: Mon, 29 Jul 2013 20:39:02 +0200
Message-Id: <1375123145-31648-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here's a small series of patches that add OF support to the pcf857x driver.
The first two patches prepare the driver for the third one that introduces DT
bindings and parses the device tree node.

Laurent Pinchart (3):
  gpio: pcf857x: Sort headers alphabetically
  gpio: pcf857x: Remove pdata argument to pcf857x_irq_domain_init()
  gpio: pcf857x: Add OF support

 .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 69 +++++++++++++++++++++
 drivers/gpio/gpio-pcf857x.c                        | 70 +++++++++++++++++-----
 2 files changed, 123 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt

-- 
Regards,

Laurent Pinchart

