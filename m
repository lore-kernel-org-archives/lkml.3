Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaGPUGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:06:54 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:50102 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaGPUGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:06:51 -0400
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 16 Jul 2014 21:06:18 +0100
Message-ID: <CA+V-a8unPvRPfoDNBsyyCAPCva7HokysuqG5QhcMuMrTbsCWaw@mail.gmail.com>
Subject: [GIT PULL FOR v3.17] Davinci Media
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull the following patches for davinci media which include
trivial cleanups.

Thanks,
--Prabhakar Lad

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks
(2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git davinci_media

for you to fetch changes up to c219eb5c0fa71e11793cdc1456da8fe04f76b5ff:

  staging: media: davinci_vpfe: fix checkpatch warning (2014-07-16
20:48:18 +0100)

----------------------------------------------------------------
Andrey Utkin (1):
      davinci-vpfe: Fix retcode check

Dan Carpenter (1):
      davinci: vpfe: dm365: remove duplicate RSZ_LPF_INT_MASK

Lad, Prabhakar (2):
      media: davinci_vpfe: dm365_resizer: fix sparse warning
      staging: media: davinci_vpfe: fix checkpatch warning

 drivers/staging/media/davinci_vpfe/dm365_ipipe.c    | 2 ++
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c | 2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.h | 1 -
 drivers/staging/media/davinci_vpfe/dm365_resizer.c  | 4 ++--
 4 files changed, 5 insertions(+), 4 deletions(-)
