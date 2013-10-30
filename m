Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3J3XZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:25:46 -0400
Received: from fifo99.com ([67.223.236.141]:42915 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab3J3XZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:25:45 -0400
Date: Wed, 30 Oct 2013 16:25:32 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] ARM: msm: Remove 7x00 support
Message-ID: <20131030232412.GA10229@fifo99.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
 <1382993006-27359-3-git-send-email-davidb@codeaurora.org>
 <20131029132043.GA28165@fifo99.com>
 <CAOesGMhg8HN4Su9FXSeoAgmH6NVKXW+wmnreUvWH+1G6GWkkaA@mail.gmail.com>
 <87ob66nyqc.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob66nyqc.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:08:27PM -0700, Kevin Hilman wrote:
> Olof Johansson <olof@lixom.net> writes:
> 
> > I would be very happy to take more code for the older Qualcomm chipset
> > to enable full functionality for them, but it's been my impression
> > that far from all that is needed to make it a useful platform is in
> > the upstream kernel, and there's been no signs of more of it showing
> > up at least in the last two years.
> >
> > So we have a bit of a stalemate here -- the current Qualcomm team
> > wants to avoid having to deal too much with the legacy platforms --
> > they are technically quite different from the current platforms and
> > the divergence makes it hard to deal with supporting it all in a
> > modern way without risking regressions. I tend to agree with them.
> 
> As do I.
> 
> > Just like omap split between omap1 and omap2plus, I think it's a time
> > to create a mach-qcom instead, and move the modern (v7, most likely)
> > platforms there -- enable them with device tree, modern framework
> > infrastructure, etc. That way you can keep older platforms in mach-msm
> > without risk of regressions, and they have a clean base to start on
> > with their later platforms.
> 
> I think this split approach is a good compromise.
> 
> If the maintainers of the current older platforms wish to bring them up
> to modern frameworks, we can consider combining again.  If not, they the
> older platforms will take the same path as the rest of the older
> platforms that slowly fade away.
> 

So the current users of those platforms are, what SOL ?

Daniel
