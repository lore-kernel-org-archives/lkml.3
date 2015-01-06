Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbbAFLPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:15:49 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42824 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755227AbbAFLPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:15:47 -0500
Date: Tue, 6 Jan 2015 12:15:46 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] sound: soc: atmel sam9g20_wm8731: remove useless include
Message-ID: <20150106111546.GN4194@piout.net>
References: <1420536080-29181-1-git-send-email-alexandre.belloni@free-electrons.com>
 <54ABB574.30602@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ABB574.30602@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bo,

On 06/01/2015 at 18:14:12 +0800, Bo Shen wrote :
> >
> >  #include <asm/mach-types.h>
> 
> Btw, do you consider to remove this also?
> 

I just sent a patch for that. Feel free to squash both.

> >-#include <mach/hardware.h>
> >
> >  #include "../codecs/wm8731.h"
> >  #include "atmel-pcm.h"
> >

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
