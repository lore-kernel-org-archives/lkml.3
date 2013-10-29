Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab3J2RIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:08:34 -0400
Received: from fifo99.com ([67.223.236.141]:48410 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab3J2RIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:08:32 -0400
Date: Tue, 29 Oct 2013 10:08:17 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Olof Johansson <olof@lixom.net>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] ARM: msm: Remove 7x00 support
Message-ID: <20131029170817.GA13047@fifo99.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
 <1382993006-27359-3-git-send-email-davidb@codeaurora.org>
 <20131029132043.GA28165@fifo99.com>
 <CAOesGMhg8HN4Su9FXSeoAgmH6NVKXW+wmnreUvWH+1G6GWkkaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhg8HN4Su9FXSeoAgmH6NVKXW+wmnreUvWH+1G6GWkkaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 08:37:28AM -0700, Olof Johansson wrote:
> Daniel,
> 
> I would be very happy to take more code for the older Qualcomm chipset
> to enable full functionality for them, but it's been my impression
> that far from all that is needed to make it a useful platform is in
> the upstream kernel, and there's been no signs of more of it showing
> up at least in the last two years.

Some of the platform code he's removing is not compiled right now. I
would have liked to make it compile, but I don't care that much (and
they don't either) ..

> So we have a bit of a stalemate here -- the current Qualcomm team
> wants to avoid having to deal too much with the legacy platforms --
> they are technically quite different from the current platforms and
> the divergence makes it hard to deal with supporting it all in a
> modern way without risking regressions. I tend to agree with them.

Oh what a sob story .. They can't claim to maintain msm except for the
parts they don't like that much, thats not how it works. If you
have a technical reason why you think hard to maintain code is
"hard to deal with", please put that forth .

If they want they can start submitting their patches to me, and I can
deal with their "hard to deal with" stuff..

> Just like omap split between omap1 and omap2plus, I think it's a time
> to create a mach-qcom instead, and move the modern (v7, most likely)
> platforms there -- enable them with device tree, modern framework
> infrastructure, etc. That way you can keep older platforms in mach-msm
> without risk of regressions, and they have a clean base to start on
> with their later platforms.

Personally I think splitting mach- stuff isn't very useful or
interesting.. There's just no technical reason for it, for example x86
and x86_64 was a win from my perspective , there's a lot more reason to
keep similar things together than to split things up.

The whole risking regressions, do you have proof of why you think that's
happening ? The inverse seems more likely..

Daniel
