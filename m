Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaLFJvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 04:51:04 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48340 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaLFJvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 04:51:00 -0500
Date: Sat, 6 Dec 2014 01:50:46 -0800
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>,
        Brian Austin <brian.austin@cirrus.com>,
        Paul Handrigan <Paul.Handrigan@cirrus.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Timur Tabi <timur@tabi.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] sound / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Message-ID: <20141206095045.GA2624@Asurada>
References: <2064254.7lXiTpmK64@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2064254.7lXiTpmK64@vostro.rjw.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 03:46:27AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under sound/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.
> 
> ---
>  sound/pci/hda/hda_controller.c |    2 +-
>  sound/pci/hda/hda_intel.c      |    5 +----
>  sound/soc/codecs/cs35l32.c     |    2 +-
>  sound/soc/codecs/cs42xx8.c     |    2 +-
>  sound/soc/codecs/max98090.c    |    2 +-
>  sound/soc/codecs/pcm512x.c     |    2 +-
>  sound/soc/codecs/tas2552.c     |    4 ++--
>  sound/soc/codecs/wm2200.c      |    2 +-
>  sound/soc/codecs/wm5100.c      |    2 +-
>  sound/soc/codecs/wm8962.c      |    2 +-
>  sound/soc/fsl/fsl_asrc.c       |    4 ++--
>  sound/soc/samsung/i2s.c        |    4 ++--
>  12 files changed, 15 insertions(+), 18 deletions(-)

For cs42xx8.c and fsl_asrc.c

Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>

Thank you
Nic
