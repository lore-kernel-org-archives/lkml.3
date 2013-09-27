Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab3I0D20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:28:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10167 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3I0D2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:28:23 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-2e-5244fb568507
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>
Cc: "'Mike Dunn'" <mikedunn@newsguy.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        "'Robert Jarzmik'" <robert.jarzmik@free.fr>,
        "'Marek Vasut'" <marex@denx.de>,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com>
 <5244065A.8010408@ti.com> <20130926115108.GA1680@ulmo>
 <524423B6.4070609@ti.com>
In-reply-to: <524423B6.4070609@ti.com>
Subject: Re: [PATCH v2] pwm-backlight: allow for non-increasing brightness
 levels
Date: Fri, 27 Sep 2013 12:28:21 +0900
Message-id: <017a01cebb31$9df90f60$d9eb2e20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66sSOg4Prk1s/ETte2+lxLOLlTmAAf0UnA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t8zI92w3y5BBt//sVnMP3KO1eLAnx2M
	FpcXXmK1mNh0h8XiRN8HVovLu+awWdy9u4rR4k1bI6PF2lc/2SzWPXzBZHF4xQEmi1lvhC12
	73rKavFz1zwWi/Xzb7E58Hss+HyF3WPerBMsHv3rPrN67Jx1l91jdsdMVo9XF+6weNy5tofN
	Y8n196wee+b/YPXo27KK0eP4je1MHp83yQXwRHHZpKTmZJalFunbJXBltM49xVLQLlKxbMYx
	9gbGR/xdjJwcEgImEoserWCCsMUkLtxbz9bFyMUhJLCMUeLVg3XsMEXP18yBSixilNj2dT8z
	hPOLUeLx2+fMIFVsAmoSX74cBusQEYiW+Pn9NStIEbNAN4vE5WnzodpnMkpMXTaRFaSKE6jj
	5rvHjCC2sECwxO8Nb8G6WQRUJfZ9fAVWwytgK9Fy/z+ULSjxY/I9FhCbWUBLYv3O40wQtrzE
	5jVvga7gALpVXeLRX12II4wktj59xgpRIiKx78U7RpAbJASucEi0P/rLBLFLQOLb5EMsEL2y
	EpsOMEO8LClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGpXnFibnFpXrpe
	cn7uJkZIWpm4g/H+AetDjMlA6ycyS4km5wPTUl5JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFC
	AumJJanZqakFqUXxRaU5qcWHGJk4OKUaGLOOdbzZYTjP7oDGwpcPt4nozrittuqvUmb0l8/H
	fELPyf1IXtTRcGB16AqTBVM3xDxk6Y1wufywdLVbabmb9jXDJ/pnO/0Ybn42WZuh79B9PyZZ
	I2fJ9l+1edVhty2v/pg4U2NrLJdgtpc694HCppxt5ly3r3+1Nv1nev/I13Cu6EK9n7/zlyix
	FGckGmoxFxUnAgCIXBjQQQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42I5/e+xgG7Yb5cgg++1FvOPnGO1OPBnB6PF
	5YWXWC0mNt1hsTjR94HV4vKuOWwWd++uYrR409bIaLH21U82i3UPXzBZHF5xgMli1hthi927
	nrJa/Nw1j8Vi/fxbbA78Hgs+X2H3mDfrBItH/7rPrB47Z91l95jdMZPV49WFOywed67tYfNY
	cv09q8ee+T9YPfq2rGL0OH5jO5PH501yATxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZm
	Boa6hpYW5koKeYm5qbZKLj4Bum6ZOUAPKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC
	6zEyQAMJ6xgzWueeYiloF6lYNuMYewPjI/4uRk4OCQETiedr5rBB2GISF+6tB7K5OIQEFjFK
	bPu6nxnC+cUo8fjtc2aQKjYBNYkvXw6zg9giAtESP7+/ZgUpYhboZpG4PG0+VPtMRompyyay
	glRxAnXcfPeYEcQWFgiW+L3hLVg3i4CqxL6Pr8BqeAVsJVru/4eyBSV+TL7HAmIzC2hJrN95
	nAnClpfYvOYt0BUcQLeqSzz6qwtxhJHE1qfPWCFKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0L
	GFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSnrGdSOxhXNlgcYhTgYFTi4RXIcAkSYk0s
	K67MPcQowcGsJMK7PhYoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAdJpXEm9obGJmZGlk
	ZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzBVoVRivlXiht1LJyu71P0v7ZH
	8I3DezYp7fhk9yNCF7p2CF2plX5WOt8ydEmjmcgfM1VO+2nOpuLzG/fdOlKX9E2cK9IhqF2W
	v9bM4sK120qWEvdyW08oP7SOa3EGJrK/kxly9N/tXlEj/vnn05wnvi+WB/eUy2rJse+/5HZ3
	4+y9i4rOKbEUZyQaajEXFScCAH6q7wKdAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 9:08 PM, Tomi Valkeinen wrote:
> On 26/09/13 14:51, Thierry Reding wrote:
> > On Thu, Sep 26, 2013 at 01:03:06PM +0300, Tomi Valkeinen wrote:
> > [...]
> >> But if you and Thierry think this version is good, I'll take it.
> >
> > That sounds like you want to take it through the fbdev tree. Jingoo is
> > listed (along with Richard, but he hasn't been responsive to email for
> > years) as maintainer for the backlight subsystem. Furthermore back at
> 
> Ah, so they are. I just thought it falls under fbdev, as it's under
> drivers/video/ =).
> 
> I don't have any particular "want" to take it through fbdev tree. But I
> can take it.
> 
> > the time when I began working on the PWM subsystem, the backlight sub-
> > system was pretty much orphaned, and pwm-backlight was by far the
> > biggest user of the PWM subsystem. I adopted the driver at the time
> > because it needed to be updated for PWM subsystem changes.
> >
> > What's the plan going forward? Given the coupling between the PWM
> > subsystem and the pwm-backlight driver it might be useful to keep
> > maintaining it as part of the PWM subsystem. On the other hand, there's
> > some coupling between the driver and the backlight subsystem too.
> 
> And backlight is coupled with fbdev... Which is something I don't like.

+cc Laurent Pinchart,

Yes, right. 
The backlight should be de-coupled with fbdev.
I remember that Laurent Pinchart was doing this patch.

Laurent Pinchart,
Would you let us know your plan about this? :-)

> 
> > I have a couple of patches queued up for 3.13 that rework parts of the
> > driver, so it'd be good to know how you guys want to handle this.
> 
> Well. I'm happy if somebody wants to maintain the backlight side. In
> fact, I'd be happy if somebody would start restructuring it totally,
> it's rather messy. The link with fbdev should be removed, and some
> backlight drivers are actually panel drivers. However, perhaps Common
> Display Framework is required until it can be fully cleaned.

I think that some backlight drivers can be moved to 'Common Display Framework',
after 'Common Display Framework' is merged.
But, I am not sure, when it will be completed.

Best regards,
Jingoo Han

> 
> So... For the time being, I'm fine with merging pwm-backlight via any
> tree that works best. I'm presuming here that backlight framework and
> fbdev (for the parts that are relevant for backlight) are not really
> being changed, so there shouldn't be conflicts.
> 
>  Tomi
> 

