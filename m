Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbaCTMHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:07:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30055 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758475AbaCTMHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:07:08 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-40-532ad9eadbd9
Date: Thu, 20 Mar 2014 21:07:05 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Grant Grundler <grundler@chromium.org>, Tomasz Figa <t.figa@samsung.com>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Prathyush <prathyush.k@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API
 functions
Message-id: <20140320210705.19aa5192f55f263ccf271b32@samsung.com>
In-reply-to: <5329E729.4020201@gmail.com>
References: <20140314140843.ba055f28dd7ed59c46088029@samsung.com>
 <5322FD14.5090602@samsung.com>
 <20140318185605.0380c8dfe6559c06183092e5@samsung.com>
 <532861BE.7020601@samsung.com>
 <20140319100304.5e26fa43ccdfc29178b058e1@samsung.com>
 <532997D7.6090608@samsung.com>
 <CANEJEGuYz28dGT+264CYtG+Tk6htOq=u-t4PWMtsij32X0vJFA@mail.gmail.com>
 <5329D426.9020706@samsung.com>
 <CANEJEGtCdMmWXwpoky8USLOBw7jAt1bRw8or-mDK7twxAzhWpA@mail.gmail.com>
 <5329E729.4020201@gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zge6rm1rBBpvO81rcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrFYtesPo8XMW2tYHAQ8nhycx+Qxu+Eii8e/w/1MHjtn3WX3uHNtD5vH5iX1HpNv
	LGf06NuyitHj8yY5jytHzzAFcEVx2aSk5mSWpRbp2yVwZcz4e5ap4IB4xelju9gbGHcIdTFy
	ckgImEhs/dXGCmGLSVy4t56ti5GLQ0hgGaPE7V0b2GCK+hunsUMkFjFKvFvzFapqMpNEz5fN
	YFUsAqoScy92MYPYbAJaEqvnHmcEsUUE1CW+TekH62YWWMoq8eL2EbAiYYFwiVM3PrKA2LwC
	jhJTJv4Eu4NTQFPi5+7/rBAbHjFLdP58wA5xh4XEhaYOdogGQYkfk++BNTMDbdu8rYkVwpaX
	2LzmLTNIs4TAFg6Jfb8mskKcJyDxbfIhoAYOoISsxKYDzBAzJSUOrrjBMoFRbBaSsbOQjJ2F
	ZOwCRuZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCFJYOIOxvsHrA8xJgOtnMgsJZqcD0wi
	eSXxhsZmRhamJqbGRuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmHPw
	Rp9loUEll8q0xQtDJu63fsehut9EPpFDkme3fMyK0LvL3r/icTKJ1rKUe/02+O7Jj42erlfi
	1vaLXb7Xrifhtqun31jJ2HDag7ucLs7dV9bfeBCoUmZhdvRRbXjHqnppEekCrhWMBlmvuu+I
	d1v5ubif051a3h/wQ/LYlou2K6fuenJJiaU4I9FQi7moOBEA54MrphgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jAd1XN7WCDSbcYre4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7Ru+Aqm8Wmx9dYLS7vmsNmMeP8PiaLCys2sltMWXSY1eLwm3ZWi5N/
	ehkt1s94zWKxatcfRouZt9awOAh4PDk4j8ljdsNFFo9/h/uZPHbOusvucefaHjaPzUvqPSbf
	WM7o0bdlFaPH501yHleOnmEK4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQw
	V1LIS8xNtVVy8QnQdcvMAfpFSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhY
	x5gx4+9ZpoID4hWnj+1ib2DcIdTFyMkhIWAi0d84jR3CFpO4cG89WxcjF4eQwCJGiXdrvkI5
	k5kker5sZgOpYhFQlZh7sYsZxGYT0JJYPfc4I4gtIqAu8W1KPztIA7PAUlaJF7ePgBUJC4RL
	nLrxkQXE5hVwlJgy8ScriM0poCnxc/d/VogNj5glOn8+gLrDQuJCUwc7RIOgxI/J98CamYG2
	bd7WxAphy0tsXvOWeQKjwCwkZbOQlM1CUraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnCKeSa1g3Flg8UhRgEORiUe3hV7NIOFWBPLiitzDzFKcDArifBOvaEVLMSbklhZlVqUH19U
	mpNafIgxGRgeE5mlRJPzgekvryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWp
	RTBbmDg4pRoYFzuuX6Gmb/o6f52lQvT/e8GvjSzf3066OH9Z1gG7x6fNE+rW5p9x+7r8feeN
	F3J+3D8lih3C78p9tUtfsW6F2GOxnNO6EhKTrMviJrWaPdMWY95ZEpiWIDPzr9S2hlodqVSW
	DxHqMf/272a+tGBnZq3dzQ3iekFLWqM5bdn+qTrUPjXtOTJZiaU4I9FQi7moOBEAAYzsIHUD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 19:51:21 +0100, Tomasz Figa wrote:
> On 19.03.2014 19:37, Grant Grundler wrote:
> > On Wed, Mar 19, 2014 at 10:30 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> > ...
> >> As I said, AFAIK the trend is to get rid of ordering by initcalls and make
> >> sure that drivers can handle missing dependencies properly, even for
> >> "services" such as DMA, GPIO, clocks and so on, which after all are provided
> >> by normal drivers like other.
> >
> > Ok - I'm not following the general kernel dev trends. initcall()
> > levels are easy to understand and implement. So I would not be in a
> > hurry to replace them.
> >
> 
> Well, initcall level is still a way to satisfy most of dependencies, 
> i.e. all client devices with higher initcall levels will probe 
> successfully. However the other case needs to be handled as well - in 
> this case the IOMMU binding code needs to defer probe of client driver 
> if respective IOMMU is not yet available.

I now understand what is deferred probing you mentioned.
However, I worry that many existing drivers are not ready
for deferred probing.

But still I wonder if System MMU driver need to be probed in the same
initcall level.

> >>> ps. I've written IOMMU support for four different IOMMUs on three
> >>> operating systems (See drivers/parisc for two linux examples). But I
> >>> still feel like I at best have 80% understanding of how this one is
> >>> organized/works. Abstract descriptions and convoluted code have been
> >>> handicapping me (and lack of time to dig further).
> >>
> >>
> >> Well, this is one of my concerns with this driver. It isn't easy to read
> >> (and so review, maintain, extend and debug found issues).
> >
> > My postscript comment was more to explain why I'm not confident in my
> > opinion - not a reason to reject the patch series.  I still consider
> > the whole series as a step forward. But I'm not the expert here.
> 
> I fully agree with you. Other than the issues mentioned in review, the 
> patches are definitely a step forward. I'd even say that all the patches 
> that have nothing to do with device tree could be merged in their 
> current form and the code refined later. It doesn't mean that patches 
> shouldn't be reviewed now and issues spotted reported, even if they 
> could be fixed later - this is for the IOMMU subsystem maintainer to decide.
> 
> As for patches related to DT support, more care needs to be taken, as 
> bindings should be designed with stability in mind, so the refining 
> process should happen at review stage.
> 
> > Right now, with ~30 patches posted by the exynos iommu (official?)
> > maintainer, no one else who has a clue will attempt to fix or clean up
> > those kinds of problems.  i.e. it's useful to enable others to fix
> > what are essentially unspecified "design pattern" issues.
> 
> Agreed.

Let me wait for the way of binding System MMU and its master developed by Marek.

Regards,

KyongHo
