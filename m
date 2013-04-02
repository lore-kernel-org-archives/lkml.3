Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902Ab3DBNPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:15:16 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:65217 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760483Ab3DBNPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:15:14 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v7 0/2] ARM: davinci: dm355: add support for vpbe display
Date: Tue,  2 Apr 2013 18:45:02 +0530
Message-Id: <1364908504-14232-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series enables VPBE display driver on DM355.

This patch series is dependent on VPSS clock cleanup patches
(http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg25613.html)
posted.

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

 arch/arm/mach-davinci/board-dm355-evm.c |   71 ++++++++++++-
 arch/arm/mach-davinci/davinci.h         |    3 +-
 arch/arm/mach-davinci/dm355.c           |  173 ++++++++++++++++++++++++++++++-
 3 files changed, 239 insertions(+), 8 deletions(-)

-- 
1.7.4.1

