Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab3HBTYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:24:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:50738 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3HBTYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:24:16 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        george.cherian@ti.com
Subject: am335x: support for multiple USB instances, v3
Date: Fri,  2 Aug 2013 21:24:05 +0200
Message-Id: <1375471450-31154-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series depends on Felipe's master tree and "usb: phy:
rename nop_usb_xceiv => usb_phy_gen_xceiv" which I posted earlier. I
created a -rc3 based branch for that patch [0]. If you fine with this
please let Tony know.
I updated the child nodes & the phy generic to use two small memory spaces
instead of one huge as discussed on mailing list in the last spin.
Patch contains the cppi41 dma driver which seems to work stable so far in
host mode. Device mode is currently disabled.

The complete series as used for testing is also available at [1]

[0] git://git.breakpoint.cc/cgit/bigeasy/linux.git nop_phy-rename
[1] git://git.breakpoint.cc/cgit/bigeasy/linux.git am335x_usb

Sebastian

