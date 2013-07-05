Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab3GEQM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:12:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:45854 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab3GEQMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:12:55 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC] cppi41 dma support for musb
Date: Fri,  5 Jul 2013 18:12:42 +0200
Message-Id: <1373040764-3711-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the first patch implements a dma engine and a dma-driver for cpp41 & musb.
The TX channel seems to work, there is still some work to be done.
My current tree which I use for testing is also available at:

  git://git.breakpoint.cc/bigeasy/linux.git am335x_usb

Sebastian
