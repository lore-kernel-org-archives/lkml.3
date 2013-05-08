Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab3EHQIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:08:52 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51668 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449Ab3EHQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:08:49 -0400
Date: Wed, 8 May 2013 18:08:39 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 6/6] ASoC: ux500: Use the first two AD slots for capture
Message-ID: <20130508160839.GC12970@balto.lan>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-7-git-send-email-fabio.baltieri@linaro.org>
 <20130508105654.GC7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508105654.GC7478@sirena.org.uk>
X-Operating-System: Linux balto 3.9.0-rc8-00030-g4cbbd1d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 11:56:54AM +0100, Mark Brown wrote:
> On Wed, May 08, 2013 at 09:14:21AM +0200, Fabio Baltieri wrote:
> > Set AD_OUT1 and AD_OUT2, corresponding to LINL and LINR pins, as the
> > default input slots for the capture interfaces.
> 
> If these are routing specific analogue inputs to specific timeslots then
> this is routing that should be being exposed to DAPM as muxes, not hard
> coded in the middle of TDM slot configuration (which is both obscure and
> not what the TDM API is there for).  The TDM API should be purely about
> placing the timeslots for the audio interface on the bus.

Ok, it makes sense.  Again, this patch was wrote as a fix to the
existing codebase to make the driver usable with the actual board
available to the community (the snowball).

Fabio

-- 
Fabio Baltieri
