Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3BPLii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 06:38:38 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63657 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3BPLih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 06:38:37 -0500
From: Anil Kumar <anilk4.v@gmail.com>
To: devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, b-cousson@ti.com, tony@atomide.com,
        grant.likely@secretlab.ca, zonque@gmail.com, thomas@tomweber.eu,
        anilk4.v@gmail.com
Subject: [PATCH 0/2] arm/dts: OMAP3: Add gpmc DT node support
Date: Sat, 16 Feb 2013 17:08:26 +0530
Message-Id: <1361014708-1659-1-git-send-email-anilk4.v@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpmc DT node in dtsi file.
Add nand DT node and partitions information for devkit8000.

This series is based on top of branch “omap-for-v3.9/gpmc” git tree 
http://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git
and patches.

Anil Kumar:-
ARM: dts: add minimal DT support for DevKit8000

Jon Hunter:- 
  ARM: OMAP2+: Fix-up gpmc merge error

Done basic testing:-
 - #cat /proc/mtd     (shows nand partitions) 
 - Nand partitions by command line.

Anil Kumar (2):
  ARM: dts: omap3: Add gpmc node
  ARM: dts: omap3-devkit8000: add nand dt node

 arch/arm/boot/dts/omap3-devkit8000.dts |   52 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap3.dtsi           |   11 +++++++
 2 files changed, 63 insertions(+), 0 deletions(-)

