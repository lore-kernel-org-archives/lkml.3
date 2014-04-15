Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaDOIzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:55:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42282 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaDOIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:55:48 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-a2-534cf4116474
Message-id: <1397552145.29169.17.camel@AMDC1943>
Subject: Re: [PATCH 4/4] regulator: s5m8767: Use same binding for external
 control as in s2mps11
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Tue, 15 Apr 2014 10:55:45 +0200
In-reply-to: <CAK9yfHwUwjMEXisi5Jf+nAkS7CLnAUt-REkekns9JrRTAGQ=WQ@mail.gmail.com>
References: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
 <1397462949-22379-5-git-send-email-k.kozlowski@samsung.com>
 <20140414211106.GC12304@sirena.org.uk>
 <CAK9yfHwL4o7-7Q03dw9JdD1UDsP_v2=we1kadRXaGAuaN1de_g@mail.gmail.com>
 <1397549539.29169.2.camel@AMDC1943>
 <CAK9yfHwUwjMEXisi5Jf+nAkS7CLnAUt-REkekns9JrRTAGQ=WQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.8.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e/4VV3BLz7BBif/WFlsnLGe1WLqwyds
	FvOPnGO16H+zkNXi3KuVjBZnm96wW9z/epTR4tuVDiaLy7vmsFnMOL+PyWLtkbvsFkuvX2Sy
	mDB9LYtF694j7BYn//QyWpzuZrW4uOILk8X6Ga9ZHIQ81sxbw+hxua+XyWPnrLvsHiuXf2Hz
	2LSqk83jzrU9bB7zTgZ69G1ZxejxeZNcAGcUl01Kak5mWWqRvl0CV8bl9+dZCi5yVRz6KtfA
	uISji5GTQ0LAROLH83ssELaYxIV769m6GLk4hASWMkrcmviXBcL5zCjx7/RDVpAqXgEDidMb
	z7GD2MICSRKL76xlBrHZBIwlNi9fwgZiiwhoSbzsXs4E0swscIZV4sCtJYxdjBwcLAKqEqs+
	2IDUcAoESxyetoIRYsEjJolVX0+BLWAWUJeYNG8RM8RJShLn1q1hhFgsKPFjMsSpzALyEpvX
	vGWewCgwC0nLLCRls5CULWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREnlfdzAuPWZ1
	iFGAg1GJh3fCO+9gIdbEsuLK3EOMEhzMSiK8X176BAvxpiRWVqUW5ccXleakFh9iZOLglGpg
	7P5kmh32N9K6bXZZ+WL72qQJNvGWVhO21ny48WG5evjpt+Ur9r1Y5KGTbFzDqzNpn86FA/fZ
	FnB8l1WcGK3lUrl7r/6uh4d4XrM2x/rO9JV8/8NdhaVyo/+hhGn1XKv3eOvrXXbZ9zBuks9H
	sS03Z/x5uTu52zr/yGE3h7uavqVLk8y7fqv/V2Ipzkg01GIuKk4EAMecInyaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-04-15 at 14:02 +0530, Sachin Kamat wrote:
> On 15 April 2014 13:42, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > On wto, 2014-04-15 at 13:26 +0530, Sachin Kamat wrote:
> >> On 15 April 2014 02:41, Mark Brown <broonie@kernel.org> wrote:
> >> > On Mon, Apr 14, 2014 at 10:09:09AM +0200, Krzysztof Kozlowski wrote:
> >> >
> >> >> -     - s5m8767,pmic-ext-control-gpios: (optional) GPIO specifier for one
> >> >> +     - samsung,ext-control-gpios: (optional) GPIO specifier for one
> >> >>               GPIO controlling this regulator (enable/disable); This is
> >> >>               valid only for buck9.
> >> >
> >> > This is an incompatible change.  It's OK to deprecate the old property
> >> > but it's bad form to just remove it.
> >>
> >> I agree with Mark. Also, there is no need to make it generic.
> >
> > I thought it would be good to make it consistent and to reduce the
> > number of bindings with same meaning on similar drivers.
> 
> How about making the other one use "s5m8767,pmic-ext-control-gpios"
> compatible instead of introducing a new one?

But then we would introduce semi-generic binding with a driver-specific
name.

Anyway more drivers seem to use this kind of binding (tps65090, max8952,
da9055, arizona) so maybe there is a point in making this generic?

Best regards,
Krzysztof

