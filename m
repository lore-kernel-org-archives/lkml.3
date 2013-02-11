Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab3BKFOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 00:14:34 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64445 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3BKFOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 00:14:32 -0500
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 11 Feb 2013 10:44:10 +0530
Message-ID: <CA+V-a8vKd29w5gjZgVQDT8gXVXPkovtz=wwJBOsk4nRtfCVeFA@mail.gmail.com>
Subject: [GIT PULL FOR v3.9] media i2c feature enhancements
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Martin Bugge <marbugge@cisco.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull the following patches for media-i2c. The first patch adds support
for ths7353 video amplifier, the second patch adds decoder as media entity and
the third and fourth patch enables media controller support usage for
tvp7002 and
tvp514x respectively.

Regards,
--Prabhakar Lad


The following changes since commit 4880f56438ef56457edd5548b257382761591998:

  [media] stv0900: remove unnecessary null pointer check (2013-02-08
18:05:48 -0200)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git media-i2c-fixes

Lad, Prabhakar (1):
      media: ths7353: add support for ths7353 video amplifier

Manjunath Hadli (3):
      media: add support for decoder as one of media entity types
      media: tvp7002: enable TVP7002 decoder for media controller
      media: tvp514x: enable TVP514X for media controller based usage

 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |   10 +
 drivers/media/i2c/Kconfig                          |    6 +-
 drivers/media/i2c/ths7303.c                        |  353 ++++++++++++++++----
 drivers/media/i2c/tvp514x.c                        |  158 +++++++++-
 drivers/media/i2c/tvp7002.c                        |  132 +++++++-
 include/media/ths7303.h                            |   42 +++
 include/media/tvp7002.h                            |    2 +
 include/media/v4l2-chip-ident.h                    |    3 +
 include/uapi/linux/media.h                         |    2 +
 9 files changed, 636 insertions(+), 72 deletions(-)
 create mode 100644 include/media/ths7303.h
