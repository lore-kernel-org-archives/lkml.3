Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaG1ENx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 00:13:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33699 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG1ENt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 00:13:49 -0400
X-AuditID: cbfee690-b7f526d000003627-92-53d5cdf2a151
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, mark.brown@linaro.org,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        "'Lee Jones'" <lee.jones@linaro.org>
References: <53A05E2D.6020702@samsung.com> <5027740.B7iVUcUX2T@wuerfel>
 <53A0B27E.5010708@gmail.com> <5537724.LlmJ2hxcKn@wuerfel>
In-reply-to: <5537724.LlmJ2hxcKn@wuerfel>
Subject: RE: [PATCH RFC] mfd: syscon: Decouple syscon interface from syscon
 devices
Date: Mon, 28 Jul 2014 09:45:01 +0530
Message-id: <002701cfaa1a$82b42770$881c7650$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKN9QGh9175x+dQQ3DHKBd0w/cN3wKdDwnaAe6GAgkAzLXwuZoNgg2g
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWyRsSkTvfT2avBBp1d8hZ/Jx1jt1g26S6b
	xfddX9gtehdcZbO4//Uoo8Wmx9dYLS7vmsNmMeP8PiaL25d5LXZcu8Vicbqb1WL9jNcsFqt2
	/WG0uPlsO5MDn0dLcw+bx+9fkxg9ds66y+5x59oeNo95JwM9Ni+p9+jbsorR4/MmuQCOKC6b
	lNSczLLUIn27BK6M45PXMRZ8Fa2YsucSewPjTsEuRk4OCQETiTkbnrFD2GISF+6tZ+ti5OIQ
	EljKKLF36n9GmKL7c48wgdhCAosYJe4c9IIo+ssocXntJLBuNgFdiSfv5zJ3MXJwiAh4SbTv
	DASpYRaYxSzx920vM0RDM6PE0W0zwSZxCmhKTLo+D2yDsECoRP/uNmYQm0VAVWLpjMlgcV4B
	S4nDp9+zQdiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ4lIFiR1nX4P1igi4STyZdBGqRlxi
	0oOH7CBHSAis5ZBomr2ZDWKZgMS3yYdYQK6WEJCV2HQAao6kxMEVN1gmMErMQrJ6FpLVs5Cs
	noVkxQJGllWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYgcnh9L9nE3Yw3jtgfYgxGWj9RGYp
	0eR8YHLJK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5O
	qQbGzHdH+b9Xm3yqfpv95ouzPO8/RYcDW66HRdv0l6WY2pUxxLKtmi1ssrVrt4SpxQOVM6xX
	9mw+Lj/h4KdVxh1W2q+kjn6q1Dlf/cvn53czh/bz7JMnhn9rXhZiwfHP4DSDQebK86dFYpIf
	OC08vvbJ1jV/Dt172LfB6t5claXOTJzHc2Uqr7fPUGIpzkg01GIuKk4EAKjpe40kAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAd1PZ68GG6zsF7P4O+kYu8WySXfZ
	LL7v+sJu0bvgKpvF/a9HGS02Pb7GanF51xw2ixnn9zFZ3L7Ma7Hj2i0Wi9PdrBbrZ7xmsVi1
	6w+jxc1n25kc+DxamnvYPH7/msTosXPWXXaPO9f2sHnMOxnosXlJvUffllWMHp83yQVwRDUw
	2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXa2kUJaY
	UwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzDg+eR1jwVfRiil7LrE3MO4U7GLk
	5JAQMJG4P/cIE4QtJnHh3no2EFtIYBGjxJ2DXl2MXED2X0aJy2snsYMk2AR0JZ68n8vcxcjB
	ISLgJdG+MxCkhllgFrPE37e9zBANzYwSR7fNBJvKKaApMen6PEYQW1ggVKJ/dxsziM0ioCqx
	dMZksDivgKXE4dPv2SBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHGpgsSOs6/BekUE3CSe
	TLoIVSMuMenBQ/YJjEKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjOPU8k97BuKrB4hCjAAejEg+vRfDVYCHWxLLiytxDjBIczEoivC/bgUK8KYmVValF+fFF
	pTmpxYcYTYE+ncgsJZqcD0yLeSXxhsYm5qbGppYmFiZmlkrivAdbrQOFBNITS1KzU1MLUotg
	+pg4OKUaGDuWsj9Q9OUPddsuuqG8ybTf8Xrhyxf34/umvxP62aLZXiba4LjpqqNb36J3zBIq
	vBsm/u/90bvLLvFFv0uAQNGKf9zsZz1vrWVbImubtM7h9KS4VWbip5SOKi9dtC87Yuny9+96
	KkJfdHjE8tYXqUeWcx3m2He7mrWGca2u7tNV6TddY9j/KbEUZyQaajEXFScCAEVkywhTAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wednesday, June 18, 2014 Arnd wrote:
> To: Tomasz Figa
> Cc: linux-arm-kernel@lists.infradead.org; mark.brown@linaro.org; Tomasz
Figa;
> linux-samsung-soc@vger.kernel.org; Kukjin Kim; Russell King - ARM Linux;
Samuel
> Ortiz; Pankaj Dubey; linux-kernel@vger.kernel.org; joshi@samsung.com;
> vikas.sajjan@samsung.com; chow.kim@samsung.com; Lee Jones
> Subject: Re: [PATCH RFC] mfd: syscon: Decouple syscon interface from
syscon
> devices
> 
> On Tuesday 17 June 2014 23:26:22 Tomasz Figa wrote:
> > On 17.06.2014 17:42, Arnd Bergmann wrote:
> > > This seems like a reasonable way of solving the problem, but I think
> > > there is an even better one that we have about in the past: if we
> > > promote syscon from a platform driver into a a drivers/base/ helper
> > > that is independent of the platform device matching, we can use call
> > > syscon_regmap_lookup_* for any device node, whether it's already
> > > bound to a driver or not, which do what you need. It would also make
> > > it easier to call the syscon code before the platform_device
> > > infrastructure gets initialized, which is something a number of
> > > people have asked for, e.g. for using regmap to do SMP bringup or
> > > for clock registration.
> >
> > Basically, unless I'm missing your point, this is what my patch does,
> > except that I don't move it to drivers/base/ and the registration
> > function I added require a pointer to struct device. Indeed,
> > decoupling it further from the driver model, by adding
> > of_syscon_register() should be useful for early users.
> 
> I believe the part you are missing is that with the approach I suggested,
there would
> be no registration function at all. You can easily do the lookup from the
client drivers
> using the DT data structures, with no need for the device at all. 

Will you please elaborate more on this? 

The only exception
> today is the clps711x platform using syscon_regmap_lookup_by_pdevname(),
but
> that should be solved in 3.17 when clps711x becomes DT-only.
> 

Does it mean that this may become a blocking issue for this patch to go
before 3.17?
If yes, isn't it will be good to accept this patch as it is if it's not
causing issue or breaking
anything with existing users of syscon. At least for our use of converting
Exynos PMU and
PM related consolidation this change is working fine and we have verified
it.

> > Should I move this to drivers/base/, even though from current location
> > it can be used outside the platform driver anyway?
> 
> Thinking about it some more, drivers/of might be better than drivers/base.
> It depends a bit where we are heading with this, in particular if we
expect to see non-
> DT users in the future.
> 
> 	Arnd

Thanks,
Pankaj Dubey

