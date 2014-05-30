Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbaE3IKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:10:53 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4239 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487AbaE3IKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:10:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 30 May 2014 01:03:35 -0700
Date: Fri, 30 May 2014 11:10:43 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Saravana Kannan <skannan@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] clk: flatten clk tree in debugfs
Message-ID: <20140530081043.GO5961@tbergstrom-lnx.Nvidia.com>
References: <1400842772-4862-1-git-send-email-pdeschrijver@nvidia.com>
 <537FCAA0.6080106@codeaurora.org>
 <20140526111453.GE5961@tbergstrom-lnx.Nvidia.com>
 <53862142.8080006@codeaurora.org> <20140528185210.10062.16299@quantum>
 <538656C1.3090402@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <538656C1.3090402@codeaurora.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> >> Mike, others,
> >>
> >> Any objections to this idea? If there's not much opposition, then maybe
> >> Peter can actually spend time fixing and testing this patch?
> >
> > Idea seems fine. I had actually considered removing the hiearchal
> > directory structure completely with the advent of clk_dump and
> > clk_summary, but if there is value in the flattened directory structure
> > then I'm all for it.
> I think the additional value of the flattened directory probably comes 
> from internal tree patches that would add set rate capability to clocks, 
> etc that would be helpful with testing.
> 

Yes. Eg. I posted a patch to dump a clocks registers for Tegra.

> Agree with all the comments so far.
> 
> Peter,
> 
> Looks like there's some support and no opposition so far. So do you want 
> to send out a real patch that's been tested and with the comments above 
> taken care of?

Yes. I will do that.

Cheers,

Peter.
