Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbaHGJa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:30:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17783 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbaHGJaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:30:52 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-93-53e3474844d8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Eric Miao'" <eric.y.miao@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Ajay Kumar'" <ajaykumar.rs@samsung.com>
References: <1406806970-12561-1-git-send-email-thierry.reding@gmail.com>
 <20140731115429.GA12627@ulmo>
In-reply-to: <20140731115429.GA12627@ulmo>
Subject: Re: [RFC] pwm-backlight: Allow backlight to remain disabled on boot
Date: Thu, 07 Aug 2014 18:30:47 +0900
Message-id: <009e01cfb222$4555d940$d0018bc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+stjT8hdopeKZZQ4GRVQcnKt/GbAFak0YQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t8zQ10P98fBBr9f81gceH+QxeLozolM
	FvOPnGO12NF2nM2i/81CVotzr1YyWlxeeInV4v7Xo4wWmx5fY7U40feB1eLyrjlsFrcv81os
	vX6RyWLC9LUsFusevmCyaN17hN3i5655LBbr599icxDyWDNvDaNHS3MPm8flvl4mj52z7rJ7
	rFz+hc3j1YU7LB6bVnWyedy5tofNY/OSeo++LasYPY7f2M7k8XmTXABPFJdNSmpOZllqkb5d
	AlfGruPqBb/4KnqvXmBsYHzG3cXIySEhYCJxbsUxZghbTOLCvfVsXYxcHEICyxglHsz7zQ5T
	dOvueiaIxCJGiWnXDkE5vxkl/rf2gLWzCahJfPlyGKxDRKBMYsb0M+wgRcwCV1kkPs25B9TB
	AdSRIfFkCVgNp4CWxKEFS5hAbGEBH4kb+9vB5rAIqErMn3IBrJxXwFbi1lxBkDCvgKDEj8n3
	WEBsZqDW9TuPM0HY8hKb17xlBimXEFCXePRXF+ICI4mzpzYyQ5SISOx78Y4R5BoJgTccEk/W
	bIRaJSDxbfIhFoheWYlNB6ABISlxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFS
	epGhXnFibnFpXrpecn7uJkZIqundwXj7gPUhxmSg9ROZpUST84GpKq8k3tDYzMjC1MTU2Mjc
	0ow0YSVx3qSHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGBViQn5t9PI1j302sfn5BiaG
	pMeMxUrJNhOkv2fr2t+7+fDws68HVecHXXc6EiXNbqM/Z8+WsnmdP5gCNJpflPcoq3IoaAtu
	EjQtmrTn6Fun4rtlBQ7sslUpP+bM93F8fWXT/PxQJckQltV8v3abhsX29y4W239KXkTLQ7Dg
	btLTxEquYuYZSizFGYmGWsxFxYkA+cDKG0sDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsVy+t9jAV0P98fBBvc3sFsceH+QxeLozolM
	FvOPnGO12NF2nM2i/81CVotzr1YyWlxeeInV4v7Xo4wWmx5fY7U40feB1eLyrjlsFrcv81os
	vX6RyWLC9LUsFusevmCyaN17hN3i5655LBbr599icxDyWDNvDaNHS3MPm8flvl4mj52z7rJ7
	rFz+hc3j1YU7LB6bVnWyedy5tofNY/OSeo++LasYPY7f2M7k8XmTXABPVAOjTUZqYkpqkUJq
	XnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Qf0oKZYk5pUChgMTiYiV9
	O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjF3H1Qt+8VX0Xr3A2MD4jLuLkZNDQsBE4tbd9UwQ
	tpjEhXvr2boYuTiEBBYxSky7dogJwvnNKPG/tYcZpIpNQE3iy5fD7CC2iECZxIzpZ9hBipgF
	rrJIfJpzD6iDA6gjQ+LJErAaTgEtiUMLloBtEBbwkbixvx1sDouAqsT8KRfAynkFbCVuzRUE
	CfMKCEr8mHyPBcRmBmpdv/M4E4QtL7F5zVtmkHIJAXWJR391IS4wkjh7aiMzRImIxL4X7xgn
	MArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4ET2TGoH48oG
	i0OMAhyMSjy8Fk2PgoVYE8uKK3MPMUpwMCuJ8FZbPw4W4k1JrKxKLcqPLyrNSS0+xGgK9OdE
	ZinR5Hxgks0riTc0NjEzsjQyszAyMTdXEuc90GodKCSQnliSmp2aWpBaBNPHxMEp1cA4JWEf
	W/2fJWxp3MJyD1MuCd6Rep7AULn97Pl9ZTsnJsU8XOntXal49Ym5z9ZDickx1/9fbFzLEWt5
	/kAyq+h63w8LhTtjJL5NfR0/kaEkftNbjte/Lp1yO/Fg3UvWxGi1maUJBo9D7i/bcFa7ZLu3
	OZO3j5g7h+KhptgLV5a4nNVdx/JwUoKCEktxRqKhFnNRcSIACJJ8InoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2014 8:55 PM, Thierry Reding wrote:
> On Thu, Jul 31, 2014 at 01:42:50PM +0200, Thierry Reding wrote:
> [...]
> > @@ -317,6 +319,12 @@ static int pwm_backlight_probe(struct platform_device *pdev)
> >  	}
> >
> >  	bl->props.brightness = data->dft_brightness;
> > +
> > +	if (data->boot_off)
> > +		bl->props.power = FB_BLANK_POWERDOWN;
> > +	else
> > +		bl->props.power = FB_BLANK_UNBLANK;
> > +
> >  	backlight_update_status(bl);
> 
> Looking at this again, perhaps a more sensible thing to do would be to
> not call backlight_update_status() in the first place. For example if
> the board defines that backlight should be kept off at boot, but the
> bootloader had already enabled it, then this would effectively turn off
> the backlight again.

(+cc Ajay Kumar)

Personally, I prefer not to call backlight_update_status(), when the
backlight was already turned on by bootloader. Also, it would be better
for subsystems such as DRM to handle the power of panel.

> 
> I think it's safe to assume that if the bootloader sets up the backlight
> then it would also set up the display. Therefore not touching the
> backlight state at all at probe time seems like the safest default.
> 
> Of course that doesn't help people who use some dumb framebuffer driver
> and therefore nothing explicitly enables the backlight. So it would
> still be changing behaviour for people for whom the bootloader doesn't
> set up the backlight at all and who therefore rely on the kernel to turn
> it on.
> 
> We could perhaps alleviate that pain a little by making this dependent
> on whether or not the board is booted using DT on the assumption that
> anything that uses DT would be "modern" enough to provide a means to
> automatically enable the backlight at the right moment.

I also agree with the way to use DT.

Best regards,
Jingoo Han

> 
> Thierry

