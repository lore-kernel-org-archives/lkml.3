Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaHYKPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:15:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57048 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbaHYKPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:15:30 -0400
Date: Mon, 25 Aug 2014 11:15:23 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, sameo@linux.intel.com, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3 v4 RESEND] mfd: arizona: Export function to control
	subsystem DVFS
Message-ID: <20140825101523.GA1245@opensource.wolfsonmicro.com>
References: <20140808133233.GA2665@opensource.wolfsonmicro.com> <20140821104051.GW4266@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821104051.GW4266@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 11:40:51AM +0100, Lee Jones wrote:
> On Fri, 08 Aug 2014, Richard Fitzgerald wrote:
> 
> > From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> > 
> > Moving this control from being a side-effect of the LDO1
> > regulator driver to a specific exported function.
> > 
> > Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  drivers/mfd/arizona-core.c       |   89 ++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/arizona/core.h |   12 +++++
> >  2 files changed, 101 insertions(+), 0 deletions(-)
> 
> If this is the same patch I reviewed before:
> 
>   Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> I guess we're just waiting for maintainer Acks before I can apply the
> set.
> 

Yes it is, and yes we are.

