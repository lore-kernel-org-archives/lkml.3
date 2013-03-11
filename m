Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3CKFbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:31:35 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:47562 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3CKFbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:31:33 -0400
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 11 Mar 2013 11:01:01 +0530
Message-ID: <CA+V-a8vVtqBHsDHKZS63B+7p-8gDgKuJ3sy+T+Y1kz-xjdyn7w@mail.gmail.com>
Subject: [GIT PULL FOR v3.10] DaVinci media/tvp514x/ths7353 cleanups and
 feature enhancement
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull the following patches.

A gentle request, can you please pull these patches ASAP as my TI I'd might
get shut any movement, so as the mails of patches being queued don’t get bounce.

Regards,
--Prabhakar Lad

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for_v3.10

Lad, Prabhakar (1):
      media: ths7353: add support for ths7353 video amplifier

Manjunath Hadli (2):
      media: add support for decoder as one of media entity types
      media: tvp514x: enable TVP514X for media controller based usage

Sachin Kamat (1):
      davinci_vpfe: Use module_platform_driver macro

 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |   10 +
 drivers/media/i2c/Kconfig                          |    6 +-
 drivers/media/i2c/ths7303.c                        |  351 ++++++++++++++++----
 drivers/media/i2c/tvp514x.c                        |  163 +++++++++-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |   20 +-
 include/media/ths7303.h                            |   42 +++
 include/media/v4l2-chip-ident.h                    |    3 +
 include/uapi/linux/media.h                         |    2 +
 8 files changed, 507 insertions(+), 90 deletions(-)
 create mode 100644 include/media/ths7303.h
