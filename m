Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935185Ab3DHJ1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:27:07 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56151 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934802Ab3DHJ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:27:06 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v8 0/2] ARM: davinci: dm355: add support for vpbe display
Date: Mon,  8 Apr 2013 14:56:53 +0530
Message-Id: <1365413215-3632-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series enables VPBE display driver on DM355.

This patch series is dependent on VPSS clock cleanup patches
(http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg25613.html)
posted.

Changes for v8:
1: Removed extra line after break's and defines as pointed
   by Sekhar.
2: Included Ack from Sekhar for the second patch of the series.

Changes for v7:
1: Fixed nits pointed by Sekhar for DM365 series.

Changes for v6:
1: Fixed nits pointed by Sekhar.

Changes for v5:
1: Rebased on 3.9, fix review comments pointed by Sekhar for DM365 series.

Changes for v4:
1: pass different platform names to handle different ip's.

Changes for v3:
1: Replaced obsolete preset API by timings API.

Changes for v2:
1: Removed VPSS clock alias for master and slave which was
   sent for VPSS driver. since this patch was dependent on
   patch[1]. I will revist this patch once MC(captrure driver)
   goes into mainline.
   [1] http://www.spinics.net/lists/linux-media/msg50562.html

Lad, Prabhakar (2):
  ARM: davinci: dm355: add support for v4l2 video display
  ARM: davinci: dm355 EVM: add support for VPBE display

 arch/arm/mach-davinci/board-dm355-evm.c |   71 +++++++++++++-
 arch/arm/mach-davinci/davinci.h         |    3 +-
 arch/arm/mach-davinci/dm355.c           |  167 ++++++++++++++++++++++++++++++-
 3 files changed, 233 insertions(+), 8 deletions(-)

-- 
1.7.4.1

