Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbaFLKvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:51:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:39447 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952AbaFLKvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:51:10 -0400
Date: Thu, 12 Jun 2014 12:51:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Takashi Iwai <tiwai@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: [patch 05/13] sound: Use ktime_get_ts()
In-Reply-To: <s5hlht2xvck.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.2.10.1406121250150.5170@nanos>
References: <20140611234024.103571777@linutronix.de> <20140611234607.110555376@linutronix.de> <s5hlht2xvck.wl%tiwai@suse.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Takashi Iwai wrote:

> At Wed, 11 Jun 2014 23:59:14 -0000,
> Thomas Gleixner wrote:
> > 
> > do_posix_clock_monotonic_gettime() is a leftover from the initial
> > posix timer implementation which maps to ktime_get_ts().
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Jaroslav Kysela <perex@perex.cz>
> > Cc: Takashi Iwai <tiwai@suse.de>
> 
> Shall I apply these patches 5 and 6 to sound git tree, or would you
> like to apply all in tip tree instead?  In the latter case, feel free
> to take my ack for both patches:
> 
>   Reviewed-by: Takashi Iwai <tiwai@suse.de>

Please take them via sound.

Thanks,

	tglx
