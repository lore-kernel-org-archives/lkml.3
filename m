Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaI2SHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:07:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:53228 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaI2SG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:06:58 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org
Subject: [PATCH 00/13 v10] omap 8250 based UART + DMA 
Date: Mon, 29 Sep 2014 20:06:36 +0200
Message-Id: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The queue is getting smaller. The highlights of v9…v10
- the DMA stall Frans Klaver reported which popped up in yocto is gone. It
  also seems that the "ack the err-irq even if nothing happened" in EDMA
  can be dropped.
- the RX- and TX-DMA callbacks are now OMAP-only and no "bugs" flags are
  introduced into the generic DMA code. This also means that there is
  custom IRQ routine in case of DMA.

Sebastian

