Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968Ab3DHJRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:17:31 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:44013 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251Ab3DHJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:17:27 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v9 0/2] ARM: davinci: add support for dm365 vpbe display
Date: Mon,  8 Apr 2013 14:47:14 +0530
Message-Id: <1365412636-3468-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series enables VPBE display driver on DM365.

Changes for v9:
1: Removed extra line after break's and defines as pointed
   by Sekhar.
2: Included Ack's from Sekhar.

Changes for v8:
1: Fixed nits pointed by Sekhar.

Changes for v7:
1: Fixed nits pointed by Sekhar.

Changes for v6:
1: Fixed review comments pointed by Sekhar.

Changes for v5:
1: pass different platform names to handle different ip's.
2: Fixed review comments pointed by Sekhar.

Changes for v4:
1: Replaced the obsolete preset API by timings API.

Changes for v3:
1: Removed VPSS clock alias for master and slave which was
   sent for VPSS driver. since this patch was dependent on
   patch[1]. I will revist this patch once MC(captrure driver)
   goes into mainline.
[1] http://www.spinics.net/lists/linux-media/msg50562.html

Changes for v2:
1: Added VPSS clock so that capture and display
   can work independent.


Lad, Prabhakar (2):
  ARM: davinci: dm365: add support for v4l2 video display
  ARM: davinci: dm365 EVM: add support for VPBE display

 arch/arm/mach-davinci/board-dm365-evm.c |  166 +++++++++++++++++++++++++++-
 arch/arm/mach-davinci/davinci.h         |    7 +-
 arch/arm/mach-davinci/dm365.c           |  184 ++++++++++++++++++++++++++++---
 3 files changed, 340 insertions(+), 17 deletions(-)

-- 
1.7.4.1

