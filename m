Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaIETDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:03:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:33609 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaIETDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:03:10 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
Date: Fri,  5 Sep 2014 21:02:35 +0200
Message-Id: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my complete queue fo the omap serial driver based on the 8250 core
code. I played with it on beagle bone, am335x-evm and dra7xx including DMA.
The runtime-pm pieces look now bug-compatible with the omap-serial driver.
Besides the runtime-om improvement I also fixed a few corner cases for the
TX-DMA problem. The DMA fixes (in edma and omap-dma) were dropped and the
problem has been in 8250-dma via patch #13.

The whole queue is available at
  git://git.breakpoint.cc/bigeasy/linux.git uart_v8

Sebastian


