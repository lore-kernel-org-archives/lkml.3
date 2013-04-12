Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3DLIuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:50:32 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:63131 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3DLIu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:50:28 -0400
MIME-Version: 1.0
In-Reply-To: <CA+V-a8sko61y73odE5efJWwqYyMkBqM7_FPrs7Uvh7sdtBsGvA@mail.gmail.com>
References: <CA+V-a8sko61y73odE5efJWwqYyMkBqM7_FPrs7Uvh7sdtBsGvA@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 12 Apr 2013 14:20:06 +0530
Message-ID: <CA+V-a8u+jNizu8EFfmwwh6kSr913n1JAFkx7r3_MfXrCyWnG0g@mail.gmail.com>
Subject: Re: [GIT PULL FOR v3.10] DaVinci media cleanups + Updates
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans/Mauro,

I have included two more patches in the pull, following is the fresh
pull request.

Regards,
--Prabhakar

The following changes since commit 81e096c8ac6a064854c2157e0bf802dc4906678c:

  [media] budget: Add support for Philips Semi Sylt PCI ref. design
(2013-04-08 07:28:01 -0300)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for_v3.10

Lad, Prabhakar (8):
      davinci: vpif: add pm_runtime support
      media: davinci: vpss: enable vpss clocks
      media: davinci: vpbe: venc: move the enabling of vpss clocks to driver
      davinic: vpss: trivial cleanup
      ARM: davinci: dm365: add support for v4l2 video display
      ARM: davinci: dm365 EVM: add support for VPBE display
      ARM: davinci: dm355: add support for v4l2 video display
      ARM: davinci: dm355 EVM: add support for VPBE display

Sekhar Nori (1):
      media: davinci: kconfig: fix incorrect selects

 arch/arm/mach-davinci/board-dm355-evm.c      |   71 +++++++++-
 arch/arm/mach-davinci/board-dm365-evm.c      |  166 ++++++++++++++++++++++-
 arch/arm/mach-davinci/davinci.h              |   11 ++-
 arch/arm/mach-davinci/dm355.c                |  174 ++++++++++++++++++++++--
 arch/arm/mach-davinci/dm365.c                |  195 +++++++++++++++++++++++---
 arch/arm/mach-davinci/dm644x.c               |    9 +-
 arch/arm/mach-davinci/pm_domain.c            |    2 +-
 drivers/media/platform/davinci/Kconfig       |  103 +++++---------
 drivers/media/platform/davinci/Makefile      |   17 +--
 drivers/media/platform/davinci/dm355_ccdc.c  |   39 +-----
 drivers/media/platform/davinci/dm644x_ccdc.c |   44 ------
 drivers/media/platform/davinci/isif.c        |   28 +---
 drivers/media/platform/davinci/vpbe_venc.c   |   25 ++++
 drivers/media/platform/davinci/vpif.c        |   24 +---
 drivers/media/platform/davinci/vpss.c        |   36 ++++-
 15 files changed, 692 insertions(+), 252 deletions(-)
