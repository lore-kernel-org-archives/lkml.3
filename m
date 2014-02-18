Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaBRJFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:05:02 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51186 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184AbaBRJE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:04:58 -0500
Date: Tue, 18 Feb 2014 09:04:54 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, eric.y.miao@gmail.com,
        dmitry.torokhov@gmail.com, lgirdwood@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        peter.ujfalusi@ti.com, cw00.choi@samsung.com, myungjoo.ham@samsung.com,
        linux@arm.linux.org.uk, jarkko.nikula@bitmer.com
Subject: Re: [alsa-devel] [PATCH 02/15] ASoC: dapm: Add locked version of
	snd_soc_dapm_xxxx_pin functions
Message-ID: <20140218090454.GA18502@opensource.wolfsonmicro.com>
References: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1392655903-24537-3-git-send-email-ckeepax@opensource.wolfsonmicro.com> <5302417B.3070408@metafoo.de> <20140218003030.GH2669@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218003030.GH2669@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:30:30AM +0900, Mark Brown wrote:
> On Mon, Feb 17, 2014 at 06:06:03PM +0100, Lars-Peter Clausen wrote:
> 
> > Hm, this is a bit confusing. For other functions in ASoC when we
> > have a pair of functions with the _locked suffix and without the one
> > with _locked takes the lock, the other one doesn't. E.g.
> > snd_soc_update_bits_locked. Here we do it the other way around.
> 
> Yes, this is definitely confusing.  The existing naming might not be the
> best but making things inconsistent isn't going to help the situation
> either.

Oops... sorry that was not intentional I will respin to correct
this.

Thanks,
Charles

> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel

