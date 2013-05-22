Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3EVSMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:12:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52930 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3EVSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:12:28 -0400
Date: Wed, 22 May 2013 20:12:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: use the exact frequency for
 clk_set_rate()
In-Reply-To: <20130328020732.GF5429@S2101-09.ap.freescale.net>
Message-ID: <Pine.LNX.4.64.1305222000510.12715@axis700.grange>
References: <Pine.LNX.4.64.1302251820431.3030@axis700.grange>
 <Pine.LNX.4.64.1303272345260.9558@axis700.grange>
 <20130328020732.GF5429@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:+hTP7WMs+/p9/L9wUvFVaeFaXhuf/qQhQW8NRvvEgDg
 QqiiGO5UrYPz92pcz3YSlfkKATt2FgxJs189i2j1ES2/LFPUTV
 9sW5oqSa3C60+3GMlC2UjhqXYquN4xn9XJEWj02sVTqitIKyR7
 GfVpCg74y5kHq82mVGq/YEnufI9ru7z0Ig2r8cqXm6dVDzcqAn
 3lr8VolCTYowsJm7ujFlbvLi2l2vZzV4RoK38PETjZEgbrNU7m
 WGIbprrv+bQdamX8LmXrO59VJ3qbdac9OIaWFgoJh8dh/baqJl
 mRzbYNyprjkc5OHwX8TPo6mx9FXHAUExHXBxCn7SFiObRVrrUR
 +3PRtzeAsvV7NWyi/8owcV+QcFFpAwKePbK4FrcSli4SYK8Eln
 GNEVjl1+0P7cQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael

I don't see this patch in your cpufreq branch nor in next or Linus' trees, 
has it been pulled yet?

Thanks
Guennadi

On Thu, 28 Mar 2013, Shawn Guo wrote:

> On Wed, Mar 27, 2013 at 11:46:38PM +0100, Guennadi Liakhovetski wrote:
> > Hi Shawn
> > 
> > On Mon, 25 Feb 2013, Guennadi Liakhovetski wrote:
> > 
> > > clk_set_rate() isn't supposed to accept approximate frequencies, instead
> > > a supported frequency should be obtained from clk_round_rate() and then
> > > used to set the clock.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > Can I have your ack for this one, please?
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
