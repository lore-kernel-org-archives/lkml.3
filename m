Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaG2TAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:00:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:50343 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaG2TAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:00:17 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com
Subject: dma support for 8250-omap serial driver
Date: Tue, 29 Jul 2014 20:58:57 +0200
Message-Id: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series is on top of "[PATCH v4] 8250-core based serial driver for OMAP".
I will refresh it once I fixed the runtime-pm issue.
Patches 1-3 are independent of the series and just bug fixes. Patches 4+ are
RFC only for now. Its been tested on dra7, am33xx won't work as-is (even with
patch 5 providing dts nodes).

The complete series ontop of of v3.16-rc5 is also available at
	git://git.breakpoint.cc/bigeasy/linux.git uart_v5_dma

Sebastian

