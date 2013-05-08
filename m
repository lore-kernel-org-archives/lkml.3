Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3EHLM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:12:58 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51913 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3EHLM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:12:57 -0400
Date: Wed, 8 May 2013 12:12:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 6/6] ASoC: ux500: Use the first two AD slots for capture
Message-ID: <20130508111253.GE3459@gmail.com>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-7-git-send-email-fabio.baltieri@linaro.org>
 <20130508105654.GC7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130508105654.GC7478@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 May 2013, Mark Brown wrote:

> On Wed, May 08, 2013 at 09:14:21AM +0200, Fabio Baltieri wrote:
> > Set AD_OUT1 and AD_OUT2, corresponding to LINL and LINR pins, as the
> > default input slots for the capture interfaces.
> 
> If these are routing specific analogue inputs to specific timeslots then
> this is routing that should be being exposed to DAPM as muxes, not hard
> coded in the middle of TDM slot configuration (which is both obscure and
> not what the TDM API is there for).  The TDM API should be purely about
> placing the timeslots for the audio interface on the bus.

Again, I think this patch is a valid bugfix. If the driver requires
refactoring, it should be done by someone else. That's not the purpose
of Fabio's role.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
