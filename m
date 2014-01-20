Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaATUDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 15:03:42 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60242 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaATUDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 15:03:39 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8804: Allow control of master clock divider in PLL generation
From: Daniel Matuschek <daniel@matuschek.net>
In-Reply-To: <20140117122204.GR17314@sirena.org.uk>
Date: Mon, 20 Jan 2014 21:03:33 +0100
Cc: alsa-devel@alsa-project.org, Dimitris.Papastamos@wolfsonmicro.com,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A9E51959-7197-442F-9E43-A1D3FD434C46@matuschek.net>
References: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform> <20140117122204.GR17314@sirena.org.uk>
To: Mark Brown <broonie@kernel.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry for this. Looks like I still had problems with some whitespaces. I will resend the patch and hope, it will work now.

Daniel

Am 17.01.2014 um 13:22 schrieb Mark Brown <broonie@kernel.org>:

> On Tue, Jan 14, 2014 at 08:34:10PM +0100, Daniel Matuschek wrote:
> 
>> WM8804 can run with PLL frequencies of 256xfs and 128xfs for
>> most sample rates. At 192kHz only 128xfs is supported. The
>> existing driver selects 128xfs automatically for some lower
> 
> This patch doesn't apply against current code.  Please check and resend,
> from MAINTAINERS:
> 
> SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)
> M:      Liam Girdwood <lgirdwood@gmail.com>
> M:      Mark Brown <broonie@kernel.org>
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
> L:      alsa-devel@alsa-project.org (moderated for non-subscribers)
> W:      http://alsa-project.org/main/index.php/ASoC
> S:      Supported
> F:      Documentation/sound/alsa/soc/
> F:      sound/soc/
> F:      include/sound/soc*
> 
> specifically the for-next branch (or ideally topic/wm8804 for wm8804
> when it exists).
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel

