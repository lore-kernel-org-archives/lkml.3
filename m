Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaHKAWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 20:22:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59328 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaHKAW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 20:22:29 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-a8-53e80cc3b3ec
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        "'Guenter Roeck'" <linux@roeck-us.net>,
        "'YoungJun Cho'" <yj44.cho@samsung.com>,
        "'Inki Dae'" <inki.dae@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'satoru takeuchi'" <satoru.takeuchi@gmail.com>,
        "'Shuah Khan'" <shuah.kh@samsung.com>,
        "'stable'" <stable@vger.kernel.org>
References: <20140808213457.511493898@linuxfoundation.org>
 <53E57279.1030106@roeck-us.net> <20140809034911.GA2348@kroah.com>
 <20140809034950.GB2348@kroah.com> <53E5A0D1.10507@roeck-us.net>
 <20140809141609.GA21639@kroah.com> <53E63871.5040504@roeck-us.net>
 <CA+55aFwFMFgj2PqftqZLntjYkbm+pG8adJPMO+sD9=U67WOYkg@mail.gmail.com>
 <53E65747.9070108@roeck-us.net>
 <CA+55aFw=1YEfa+J5xLMbSycT4YBvEmgbDGN62nD1AL9-q1NPoA@mail.gmail.com>
 <20140810112127.60b195b7@canb.auug.org.au>
 <CAOesGMhmcM6JeAhYVW5MzDY5NuN6F-TeZNT2-Y11c=L3J_D7oQ@mail.gmail.com>
In-reply-to: <CAOesGMhmcM6JeAhYVW5MzDY5NuN6F-TeZNT2-Y11c=L3J_D7oQ@mail.gmail.com>
Subject: RE: [PATCH 3.16 00/17] 3.16.1-stable review
Date: Mon, 11 Aug 2014 09:22:27 +0900
Message-id: <018201cfb4fa$54a16240$fde426c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLkNmIZx7Kb6TWq3fvIPj6dvlFKoQJRQcEDAhOH6WkBkTY4XQL+mrdHAT2dFoQBwpzxfgKW+/+8AcRLiUECKUwA3wK+zkUCAbKmxBeY6iie4A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t8zI93DPC+CDY5ek7WYs34Nm0Xz4vVs
	FpPuT2CxuLxrDpvFk4VnmCxOXf/MZjFl0WFWi6mngBJb915lt/jymctiwcZHjBaP+t6yW+zd
	OZnRgdej8cYNNo+ds+6ye5yY8ZvFY//cNeweV040sXrs/N7A7tG3ZRWjx+dNcgEcUVw2Kak5
	mWWpRfp2CVwZTz+cYi/YyFfR8bSJuYFxHncXIyeHhICJxJwnkxghbDGJC/fWs3UxcnEICSxj
	lNi2cSIbTNGUv5cZIRLTGSX6JrxmAUkICfxllDhxxgfEZhPQkDj8/hk7iC0iECCx9f9GJhCb
	WeADs8SJXyUQzStZJF7Pv8wKkuAUCJY49vcQWIMw0IaOL+fAhrIIqEpMXLUMLM4rYCnR+2My
	E4QtKPFj8j0WiKHqEpPmLWKGsOUlNq95ywxxqYLEjrOvwS4VEWhglNj9dDcrRJGIxL4X78AS
	EgIrOSR+n37CDLFNQOLb5ENAUzmAErISmw5ADZKUOLjiBssERolZSHbPQrJ7FpLds5CsWMDI
	sopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJDX072C8e8D6EGMy0PqJzFKiyfnA1JJXEm9o
	bGZkYWpiamxkbmlGmrCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhT39XqaJze
	+S5o787ZYZme4vfZH8U83njRU+Rdq97+jsnmDTlLA1InRU96aua7WSxmxfuvcl5VK7xTvjQs
	OmRhetqG686V2SwdEUebjhmE8kRuLN/T+7aVJVyd7eXrPeKfvhZ+kAuSF7J3CzErY5FZeVZu
	V2/ukuR3HnJf1b61VmavlL5snarEUpyRaKjFXFScCAB9i1NXIwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jQd3DPC+CDQ48l7CYs34Nm0Xz4vVs
	FpPuT2CxuLxrDpvFk4VnmCxOXf/MZjFl0WFWi6mngBJb915lt/jymctiwcZHjBaP+t6yW+zd
	OZnRgdej8cYNNo+ds+6ye5yY8ZvFY//cNeweV040sXrs/N7A7tG3ZRWjx+dNcgEcUQ2MNhmp
	iSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlANysplCXmlAKF
	AhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM55+OMVesJGvouNpE3MD4zzuLkZODgkB
	E4kpfy8zQthiEhfurWfrYuTiEBKYzijRN+E1C0hCSOAvo8SJMz4gNpuAhsTh98/YQWwRgQCJ
	rf83MoHYzAIfmCVO/CqBaF7JIvF6/mVWkASnQLDEsb+HwBqEgbZ1fDkHNpRFQFVi4qplYHFe
	AUuJ3h+TmSBsQYkfk++xQAxVl5g0bxEzhC0vsXnNW2aISxUkdpx9zQiyTESggVFi99PdrBBF
	IhL7XrxjnMAoNAvJrFlIZs1CMmsWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIT
	zzOpHYwrGywOMQpwMCrx8B788jxYiDWxrLgy9xCjBAezkgiv51OgEG9KYmVValF+fFFpTmrx
	IUZToFcnMkuJJucDk2JeSbyhsYmZkaWRmYWRibm5kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5O
	qQbGo/7vnn/jOyzXzntL97/RpcVsAj8bC/5ZPo6YJvIvOLf8rN6Z71bvAxdrK75ZNVvk3qqY
	yU0+/ns6JUXL9X9seOZY90J+BkP5pPseCc2twvVG8us8F6bKbkibWWVjUnBAWCa4S9ws+ejW
	pOP7lh9y7utIWpzyd4V80t0VK/kzZD6oO/YsjalWYinOSDTUYi4qTgQAJ+mfGFIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> On Sat, Aug 9, 2014 at 6:21 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Linus,
> >
> > On Sat, 9 Aug 2014 10:43:51 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >>
> >> On Sat, Aug 9, 2014 at 10:15 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> >> >
> >> > ERROR (phandle_references): Reference to non-existent node or label
> >> > "disp_pd"
> >> >
> >> > ERROR: Input tree has errors, aborting (use -f to force output)
> >> > make[1]: *** [arch/arm/boot/dts/exynos5420-arndale-octa.dtb] Error 2
> >>
> >> Ok, so it's something else that was apparently known about in -next,
> >> but not mentioned when pushing to me. Oh well.
> 
> Yeah, I had missed this one since I thought the DRM guys would fix it
> in their tree when it was reported.
> 
Yeah I was not aware of the build error when I sent my tree to arm-soc for this
merge window...anyway, sorry for the error because of exynos stuff and I'll try
to look at patches more closely.

> It didn't show up for me since when I did my build/test before sending
> pull requests since that was done with a mainline branch that hadn't
> merged DRM yet.
> 
> >> The new disp_dt use was added by commit 5a8da524049c ("ARM: dts:
> >> exynos5420: add dsi node"), while commit d51cad7df871 ("ARM: dts:
> >> remove display power domain for exynos5420") removed the node.
> >>
> >> I'll leave it broken until the ARM people get around to fixing it.
> >> Likely by just removing the disp_dt line from the dsi node, but I'll
> >> let the proper people sort it out.
> >
> > Yeah, that's the correct fix (it was even tested).  Olof has the patch
> > for you.
> 
> Yep, I've got the patch to do that in my current fixes branch that
> I'll send tonight.
> 
Thanks, Olof.

And Sorry, Linus.

- Kukjin

