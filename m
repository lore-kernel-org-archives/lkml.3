Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316Ab3CHQEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:04:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:55175 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692Ab3CHQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:03:58 -0500
Date: Fri, 8 Mar 2013 17:03:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: john.stultz@linaro.org, linus.walleij@stericsson.com,
        viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        rickard.andersson@stericsson.com, vincent.guittot@linaro.org
Subject: Re: [PATCH 3/4][V2] ARM: nomadik: add dynamic irq flag to the
 timer
In-Reply-To: <513A0109.9060801@linaro.org>
Message-ID: <alpine.LFD.2.02.1303081703160.22263@ionos>
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org> <513A0109.9060801@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Mar 2013, Daniel Lezcano wrote:

> > Add the dynamic irq affinity feature to the timer clock device.
> > 
> > Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
> > Acked-by: Rickard Andersson <rickard.andersson@stericsson.com>
> > ---
> 
> Hi Linus,
> 
> AFAIU, you are ok with this patch, Rickard acked it and Vincent reviewed it.
> 
> Thomas agreed to merge it into its tree as I requested because we will
> need to wait for your tree to gain visibility to this new flag before
> submitting this patch, which can take awhile.
> 
> Could you please ack it if it is ok for you ?

I can provide a for-arm tree to pull as well. Either way fine with me.

Thanks,

	tglx
