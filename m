Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946960Ab3BHTiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:38:07 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64714 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946863Ab3BHTiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:38:03 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ARM: OMAP4: Add OMAP4 Blaze Tablet support
Date: Fri,  8 Feb 2013 21:37:48 +0200
Message-Id: <1360352269-14922-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds very basic support for OMAP4 Blaze Tablet
software development platform.

The machine for this board is already registered under number 4516:
http://www.arm.linux.org.uk/developer/machines/list.php?id=4516 

The work on this platform was going internally during last two years
and lot of the people worked on this board support on (currently)
old kernels.

The board support is started from scratch (again) basing on
board-4430sdp.c file. However, I would like to give some credits
to people who worked earlier internally on the board support
adding them as authors of the boardfile (and probably I will pick
up some approaches from old versions of sources of course so this
is reasonable).

Ruslan Bilovol (1):
  ARM: OMAP4: Add OMAP4 Blaze Tablet support

 arch/arm/mach-omap2/Kconfig                  |    7 +
 arch/arm/mach-omap2/Makefile                 |    1 +
 arch/arm/mach-omap2/board-omap4blazetablet.c |  433 ++++++++++++++++++++++++++
 3 files changed, 441 insertions(+)
 create mode 100644 arch/arm/mach-omap2/board-omap4blazetablet.c

-- 
1.7.9.5

