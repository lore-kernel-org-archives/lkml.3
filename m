Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3A3AjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:39:06 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:39755 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3A3AjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:39:03 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        eduardo.valentin@ti.com
Subject: [RFC PATCH v2 0/2] ARM: update cpuinfo to print SoC model name
Date: Wed, 30 Jan 2013 02:38:55 +0200
Message-Id: <1359506337-21619-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches update cpuinfo to print SoC
model name for ARM.
The first patch exactly makes needed changes for ARM
architecture and adds a common approach to show SoC name.
Second patch uses this approach for OMAP4 SoCs (as live
example).

Looks like there were few attempts to do similar
changes to cpuinfo without any luck (had stuck
on review) so this functionality is still not
in the kernel yet.
In this patch series the update to cpuinfo is very
short (10 lines) and easy.

Comments are welcome as usual

--------------------------------------------------
v2:
Addressed comments from Russel (changed 'CPU name' > 'SoC name')
Updatet commit messages. Updated cover letter

Ruslan Bilovol (2):
  ARM: kernel: update cpuinfo to print SoC model name
  ARM: OMAP4: setup SoC model name during ID initialisation

 arch/arm/include/asm/setup.h |    1 +
 arch/arm/kernel/setup.c      |    9 +++++++++
 arch/arm/mach-omap2/id.c     |   18 ++++++++++++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

-- 
1.7.9.5

