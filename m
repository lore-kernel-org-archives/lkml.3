Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab3GVSKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:10:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:41794 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab3GVSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:10:14 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com
Subject: am33x: multiple instances and dma support, v2
Date: Mon, 22 Jul 2013 20:09:51 +0200
Message-Id: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this series contains support for the two available MUSB instances on
AM335x and DMA support. I added dma support at the end since it depends on
the rework to support multiple instances.
Patch two "still" extends the phy-nop driver since I have to dump it
somewhere. I have no problems to replace it with George Cherian PHY driver
which was posted earlier. Infact I will to try to review it and integrate
it into my series if it fits.

The whole series is also available at
  git://git.breakpoint.cc/bigeasy/linux.git am335x_usb

Sebastian

