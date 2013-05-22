Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3EVTWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:22:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46076 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab3EVTWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:22:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: use the exact frequency for clk_set_rate()
Date: Wed, 22 May 2013 21:31:22 +0200
Message-ID: <16318112.i755nOUCKx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1305222000510.12715@axis700.grange>
References: <Pine.LNX.4.64.1302251820431.3030@axis700.grange> <20130328020732.GF5429@S2101-09.ap.freescale.net> <Pine.LNX.4.64.1305222000510.12715@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 22, 2013 08:12:22 PM Guennadi Liakhovetski wrote:
> Hi Rafael
> 
> I don't see this patch in your cpufreq branch nor in next or Linus' trees, 
> has it been pulled yet?

No, I haven't applied it yet, not sure why exactly.

In the future it's better to CC cpufreq patches to linux-pm@vger.kernel.org so
that the kernel.org Patchwork can pick them up.  I'm much less likely to
overlook them then.

This is a fix, so do we need it in 3.10-rc?

Rafael


> On Thu, 28 Mar 2013, Shawn Guo wrote:
> 
> > On Wed, Mar 27, 2013 at 11:46:38PM +0100, Guennadi Liakhovetski wrote:
> > > Hi Shawn
> > > 
> > > On Mon, 25 Feb 2013, Guennadi Liakhovetski wrote:
> > > 
> > > > clk_set_rate() isn't supposed to accept approximate frequencies, instead
> > > > a supported frequency should be obtained from clk_round_rate() and then
> > > > used to set the clock.
> > > > 
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > 
> > > Can I have your ack for this one, please?
> > 
> > Acked-by: Shawn Guo <shawn.guo@linaro.org>
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
