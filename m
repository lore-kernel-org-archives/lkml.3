Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3FELZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:25:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3FELZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:25:41 -0400
Date: Wed, 5 Jun 2013 13:25:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: use the exact frequency for
 clk_set_rate()
In-Reply-To: <16318112.i755nOUCKx@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.64.1306051323160.19739@axis700.grange>
References: <Pine.LNX.4.64.1302251820431.3030@axis700.grange>
 <20130328020732.GF5429@S2101-09.ap.freescale.net>
 <Pine.LNX.4.64.1305222000510.12715@axis700.grange> <16318112.i755nOUCKx@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:aea4VznMC3xvWcxytjqzDvG0AWOlpDn7SMtlyiv4wqU
 B8K6RPtunuadDR2dWoLYCNPEi1054FSAskZEp5/2x15GEfqwJW
 XLD8XfYrLI333JQYtMua3fBOiPIGo6ZLGVeP+k7uDAFZ4eLxQo
 xO+JMxXqUzqa3mddgsnGqQT0M6P0PQyD6XpiZrIn7DfiZE1ikB
 FIt+npd9IDI8+zVtSUvWElpnYn6E1YEHFza8Xb24NJMaz7AQ8j
 Y151dHAPv4WjQZpkP3bAXR/Z4sGcau0U1lAoQI1gqoiQZEz8A+
 LKN4Rc3hEzWJAIlh0iCH3PeGRxs7gxjemgbjk7TzS6lj0+CCDp
 jaLb4UXVkGozETbC+3o4EKOlgKMR2eYaTXF8a+1YCle4oTqhqy
 P/FPC5Ho2dTOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael

On Wed, 22 May 2013, Rafael J. Wysocki wrote:

> On Wednesday, May 22, 2013 08:12:22 PM Guennadi Liakhovetski wrote:
> > Hi Rafael
> > 
> > I don't see this patch in your cpufreq branch nor in next or Linus' trees, 
> > has it been pulled yet?
> 
> No, I haven't applied it yet, not sure why exactly.
> 
> In the future it's better to CC cpufreq patches to linux-pm@vger.kernel.org so
> that the kernel.org Patchwork can pick them up.  I'm much less likely to
> overlook them then.
> 
> This is a fix, so do we need it in 3.10-rc?

Would be good, yes.

Thanks
Guennadi

> 
> Rafael
> 
> 
> > On Thu, 28 Mar 2013, Shawn Guo wrote:
> > 
> > > On Wed, Mar 27, 2013 at 11:46:38PM +0100, Guennadi Liakhovetski wrote:
> > > > Hi Shawn
> > > > 
> > > > On Mon, 25 Feb 2013, Guennadi Liakhovetski wrote:
> > > > 
> > > > > clk_set_rate() isn't supposed to accept approximate frequencies, instead
> > > > > a supported frequency should be obtained from clk_round_rate() and then
> > > > > used to set the clock.
> > > > > 
> > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > 
> > > > Can I have your ack for this one, please?
> > > 
> > > Acked-by: Shawn Guo <shawn.guo@linaro.org>

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
