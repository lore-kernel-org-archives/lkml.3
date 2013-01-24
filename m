Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3AXFxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 00:53:23 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32775 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3AXFxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 00:53:14 -0500
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 24 Jan 2013 11:22:51 +0530
Message-ID: <CA+V-a8tndm7LJiCfQqPSa6iSxiJ1UmWL-tbxBWh9HiLvvDPwMA@mail.gmail.com>
Subject: [GIT PULL for v3.8-rc] DaVinci media fixes for v3.8
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sekhar Nori <nsekhar@ti.com>, linux-media <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull the following patches which fixes display on DA850 EVM . To
avoid conflicts I have included a arm patch, which has been Acked by
its maintainer.

Fixes :
     - adv7343 encoder: fix configuring the encoder.
     - da850: pass data for adv7343 encoder for required configuration.

Thank you!
Prabhakar

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git davinci_media

Lad, Prabhakar (2):
      media: adv7343: accept configuration through platform data
      ARM: davinci: da850 evm: pass platform data for adv7343 encoder

 arch/arm/mach-davinci/board-da850-evm.c |   13 ++++++++
 drivers/media/i2c/adv7343.c             |   36 ++++++++++++++++++---
 include/media/adv7343.h                 |   52 +++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 5 deletions(-)
