Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab3GZWps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:45:48 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:51573 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3GZWpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:45:44 -0400
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: alsa-devel@alsa-project.org
Cc: "Felipe F. Tonello" <eu@felipetonello.com>, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH v2 0/3] ALSA: Implement core jack support for kcontrol
Date: Fri, 26 Jul 2013 15:45:10 -0700
Message-Id: <1374878713-11922-1-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

Sending series again.

Difference is that previous Patch 4 was squashed with Patch 2. Also fixed
comment on Patche 3.

Felipe F. Tonello (3):
  ALSA: Added jack detection kcontrol support
  ALSA: pci: HDA/oxygen: Updating jack implementation according new ALSA
    Jacks
  ALSA: SoC: Updating jack implementation according new ALSA Jacks

 include/sound/jack.h               |  6 ++++--
 include/sound/soc.h                |  2 +-
 sound/core/Kconfig                 |  1 +
 sound/core/ctljack.c               |  3 ++-
 sound/core/jack.c                  | 29 +++++++++++++++++++++++++++--
 sound/pci/hda/Kconfig              |  8 --------
 sound/pci/hda/hda_codec.h          |  2 --
 sound/pci/hda/hda_jack.c           | 38 +++++++++++++++++---------------------
 sound/pci/hda/hda_jack.h           |  4 +---
 sound/pci/oxygen/xonar_wm87x6.c    |  2 +-
 sound/soc/fsl/wm1133-ev1.c         |  4 ++--
 sound/soc/mid-x86/mfld_machine.c   |  6 +++---
 sound/soc/omap/ams-delta.c         |  2 +-
 sound/soc/omap/omap-abe-twl6040.c  |  4 ++--
 sound/soc/omap/omap-twl4030.c      |  4 ++--
 sound/soc/omap/rx51.c              |  6 +++---
 sound/soc/pxa/hx4700.c             |  4 ++--
 sound/soc/pxa/palm27x.c            |  4 ++--
 sound/soc/pxa/ttc-dkb.c            |  8 ++++----
 sound/soc/pxa/z2.c                 |  4 ++--
 sound/soc/samsung/goni_wm8994.c    |  4 ++--
 sound/soc/samsung/h1940_uda1380.c  |  4 ++--
 sound/soc/samsung/littlemill.c     | 10 +++++-----
 sound/soc/samsung/lowland.c        |  6 +++---
 sound/soc/samsung/rx1950_uda1380.c |  4 ++--
 sound/soc/samsung/smartq_wm8987.c  |  4 ++--
 sound/soc/samsung/speyside.c       |  6 +++---
 sound/soc/samsung/tobermory.c      |  4 ++--
 sound/soc/soc-jack.c               |  4 ++--
 sound/soc/tegra/tegra_alc5632.c    |  4 ++--
 sound/soc/tegra/tegra_rt5640.c     |  2 +-
 sound/soc/tegra/tegra_wm8903.c     |  8 ++++----
 32 files changed, 107 insertions(+), 94 deletions(-)

-- 
1.8.1.4

