Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3EHLm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:42:27 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57475 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3EHLm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:42:26 -0400
Date: Wed, 8 May 2013 13:42:16 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
Message-ID: <20130508114216.GB29130@balto.lan>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508105124.GA7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508105124.GA7478@sirena.org.uk>
X-Operating-System: Linux balto 3.9.0-rc8-00030-g4cbbd1d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 11:51:24AM +0100, Mark Brown wrote:
> On Wed, May 08, 2013 at 09:14:18AM +0200, Fabio Baltieri wrote:
> > Drop pinctrl default/sleep state switching code, as it was breaking the
> > capture interface by putting the I2S pins in hi-z mode regardless of its
> > usage status, and not giving any real benefit.
> > 
> > Pinctrl default mode configuration is already managed automatically by a
> > specific pinctrl hog.
> 
> I tend to agree with Lee that this looks like a bad approach - there's a
> whole bunch of other code in there which I'd guess is probably equally
> broken but only the pinctrl code is being removed.  Why not just fix it
> (or better yet simplify all this stuff)?

Sorry I did not get the subject, are you referring to other broken code
in the ux500 driver or to pinctrl and shared pins in generals?

Fabio

-- 
Fabio Baltieri
