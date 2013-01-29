Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3A2Pyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:54:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37273 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab3A2Pyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:54:35 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>
Subject: [RFC PATCH 0/2] ARM: update cpuinfo to print CPU model name
Date: Tue, 29 Jan 2013 17:54:23 +0200
Message-ID: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches update cpuinfo to print CPU
model name for ARM. First patch exactly makes needed
changes for ARM architecture.
Second patch adds this ability to OMAP4 SoCs.

This adds a common approach to show SoC name.

Looks like there were few attempts to do similar
changes to cpuinfo without any luck.

So - comments are welcome

Ruslan Bilovol (2):
  ARM: kernel: update cpuinfo to print CPU model name
  ARM: OMAP4: setup CPU model name during ID initialisation

 arch/arm/include/asm/setup.h |    1 +
 arch/arm/kernel/setup.c      |   10 ++++++++++
 arch/arm/mach-omap2/id.c     |   18 ++++++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

-- 
1.7.9.5

