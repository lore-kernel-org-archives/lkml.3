Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab3CVIJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:09:49 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34002 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3CVIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:09:46 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v6 0/2] ARM: davinci: dm355: add support for vpbe display
Date: Fri, 22 Mar 2013 13:39:27 +0530
Message-Id: <1363939769-22506-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series enables VPBE display driver on DM355.

This patch series is dependent on VPSS clock cleanup patches
(http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg25499.html)
posted.

Chnages for v6:
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
 arch/arm/mach-davinci/davinci.h         |    2 +-
 arch/arm/mach-davinci/dm355.c           |  181 ++++++++++++++++++++++++++++++-
 3 files changed, 246 insertions(+), 8 deletions(-)

-- 
1.7.4.1

