Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbaEIOgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:36:37 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:41227 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646AbaEIOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:36:35 -0400
Date: Fri, 9 May 2014 15:36:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/2] mfd: mc13xxx: Do not use platform data with
 devicetree
Message-ID: <20140509143629.GA5767@lee--X1>
References: <1398926883-21778-1-git-send-email-shc_work@mail.ru>
 <20140509113030.GV5767@lee--X1>
 <1399643769.716496780@f345.i.mail.ru>
 <20140509141840.GZ5767@lee--X1>
 <20140509143054.GN12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140509143054.GN12304@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You need to revert (or remove) the original one and apply:
> 
> >   "ASoC: mc13783: Add devicetree support"
> 
> > ... instead.
> 
> Why not just pull the tag instead?  I haven't looked at the patch but
> don't they need to go in together anyway.

Only functionally.  They are orthogonally buildable apparently.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
