Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3EHPHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:07:36 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36378 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3EHPHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:07:35 -0400
Date: Wed, 8 May 2013 16:07:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
Message-ID: <20130508150729.GK3459@gmail.com>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508105124.GA7478@sirena.org.uk>
 <20130508114216.GB29130@balto.lan>
 <20130508123225.GK7478@sirena.org.uk>
 <20130508131020.GA30503@balto.lan>
 <20130508135413.GR7478@sirena.org.uk>
 <20130508141723.GA12155@balto.lan>
 <20130508142734.GB12155@balto.lan>
 <20130508144958.GT7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130508144958.GT7478@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 May 2013, Mark Brown wrote:

> On Wed, May 08, 2013 at 04:27:34PM +0200, Fabio Baltieri wrote:
> > On Wed, May 08, 2013 at 04:17:23PM +0200, Fabio Baltieri wrote:
> 
> > > Ok, what I'm trying to say is that the codec used in this platform
> > > should be able to handle sleep modes without requiring any
> > > reconfiguration of the digital interface on the SoC side.  In support of
> > > this the fact that the STE fork of the driver does not do that, and the
> > > same goes for all other ASoC drivers currently in mainline.
> 
> > And by the way, if the current code is *really* setting the digital
> > audio bus pins in hi-z mode (without any pull-up/down/keeper) as it
> > claims, this is not just usless, it's plain wrong.  The bus should never
> > be left floating on both sides, right?
> 
> Probably not, no.

Why don't we wait and see what LinusW says?

If anyone would know, it's him.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
