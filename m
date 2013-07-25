Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab3GYXSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:18:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20167 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3GYXSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:18:00 -0400
X-AuditID: cbfee68f-b7f436d000000f81-96-51f1b226a495
From: Jingoo Han <jg1.han@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Qing Xu'" <qingx@marvell.com>,
        "'Haojian Zhuang'" <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, "'Robin Holt'" <holt@sgi.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <1374680547-5336-1-git-send-email-olof@lixom.net>
 <000401ce88d4$33773de0$9a65b9a0$@samsung.com>
 <CAOesGMh5-aRR+eZVimNnZJ++f74tbURWOeri-46GNQfK_r3JuA@mail.gmail.com>
In-reply-to: <CAOesGMh5-aRR+eZVimNnZJ++f74tbURWOeri-46GNQfK_r3JuA@mail.gmail.com>
Subject: Re: [PATCH] mfd: max8925: fix dt code for backlight
Date: Fri, 26 Jul 2013 08:17:58 +0900
Message-id: <000f01ce898d$333a5ce0$99af16a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJzaoDSw9z/LVr2ed29jAuv8pmkhgIxTUfQAsBWXIWYBLeioA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+Zsa7apo+BBq1HlSzmrF/DZnFhnblF
	/7QOVovLCy+xWmx6fA3I2jWHzeLU9c9sFs1XuC1273rKanG6m9WBy2PnrLvsHidm/GbxmHcy
	0GPzknqPKyeaWD0mL7zI7LFn/g9Wj74tqxg97l5/yeTxeZNcAFcUl01Kak5mWWqRvl0CV8bT
	x5dZCvbyVTx6PZ2xgXErdxcjJ4eEgInE6mnHmCBsMYkL99azdTFycQgJLGOU2HeknQ2m6OWT
	pSwQiemMEn8OzYRyfjFK9E07xQxSxSagJvHly2F2EFtEQFXiyZMuVpAiZoErTBK9a18zQ3Rs
	YZRYtvICK0gVp0CwxO5JDWA7hAVsJL5s2gwWZwHq3rpiDwuIzStgKXFx2XpGCFtQ4sfke2Bx
	ZgEtifU7jzNB2PISm9e8ZYa4VUFix9nXjBBXOEmc/HiFFaJGRGLfi3eMIEdICMzlkDj8soUJ
	YpmAxLfJh4CGcgAlZCU2HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFS
	epGxXnFibnFpXrpecn7uJkZIKujfwXj3gPUhxmSg9ROZpUST84GpJK8k3tDYzMjC1MTU2Mjc
	0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjD2fYyb0pbk3HEsXm8OR8Kuv
	/o+h/skeB+ZDvrcncNxyS2zoLbrqMeHTu4u7H/g13UrVZD8Yf/rn3GPVB3VVHwfPTrmS1Xpk
	UpkQp9ADARv5jFOluWUPjQOT65v0Il9MVrDm3995f4qQWuafBPFP/xN/TPaMEmt9o/nmzOGg
	uD2/7ppP33m2RomlOCPRUIu5qDgRAEfoW/AbAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jQV21TR8DDR5fl7GYs34Nm8WFdeYW
	/dM6WC0uL7zEarHp8TUga9ccNotT1z+zWTRf4bbYvespq8XpblYHLo+ds+6ye5yY8ZvFY97J
	QI/NS+o9rpxoYvWYvPAis8ee+T9YPfq2rGL0uHv9JZPH501yAVxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCnKimUJeaUAoUCEouLlfTtME0I
	DXHTtYBpjND1DQmC6zEyQAMJ6xgznj6+zFKwl6/i0evpjA2MW7m7GDk5JARMJF4+WcoCYYtJ
	XLi3nq2LkYtDSGA6o8SfQzNZIJxfjBJ9004xg1SxCahJfPlymB3EFhFQlXjypIsVpIhZ4AqT
	RO/a18wQHVsYJZatvMAKUsUpECyxe1IDG4gtLGAj8WXTZrA4C1D31hV7wHbzClhKXFy2nhHC
	FpT4MfkeWJxZQEti/c7jTBC2vMTmNW+ZIW5VkNhx9jUjxBVOEic/XmGFqBGR2PfiHeMERqFZ
	SEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnGieSe1gXNlgcYhR
	gINRiYdXweljoBBrYllxZe4hRgkOZiUR3lu9QCHelMTKqtSi/Pii0pzU4kOMyUCfTmSWEk3O
	BybBvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgPB9e2em5
	pX/7a50Ys/NmTqsv/vK4dS9oSbXTM9mpdjOXWfD7nHYLP7n49a7N1p3tWT35rzf80vj1Nf3r
	JUe/hvLuVwobz2sIvbc2UtZwOpFnV7hi/rHybfOCK70XH/hmwlnF4yA8yyLW6+hs/l0Xco8s
	FEmfN5+xfbtB3pGtazJ3ysxa3hYjq8RSnJFoqMVcVJwIAJG2w+x4AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 26, 2013 6:01 AM, Olof Johansson wrote:
> On Wed, Jul 24, 2013 at 6:13 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Thursday, July 25, 2013 12:42 AM, Olof Johansson wrote:
> >>
> >> The device-tree enablement for max8925 has several problems, but besides
> >> the bindings being wrong (and not having seen review) there's also some
> >> bad coding practices on how to fill in the platform_data from device tree.
> >>
> >> I came across this since it causes a warning when compiling
> >> mmp2_defconfig, and instead of doing the minimal fix to silence the
> >> warning, I restructured the code a bit.
> >>
> >> This silences the warning:
> >> drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
> >> drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no effect [-Wunused-value]
> >>
> >> Note that the bindings themselves need to be revisited too, but that will
> >> affect more than just the backlight driver and is best done separately;
> >> this just fixes the bad code for the backlight driver.
> >>
> >> Signed-off-by: Olof Johansson <olof@lixom.net>
> >> ---
> >>
> >> Richard, Jingoo, this would be good to see go into 3.11 if you're
> >> comfortable with it.
> >
> > CC'ed Andrew Morton
> >
> >
> > Hi Olof Johansson,
> >
> > Currently, there is not git tree for Backlight subsystem.
> > I hope that this would go into 3.11 through one of other trees
> > with my Ack.
> >
> > If not, it will go into 3.12-rc1 through mm-tree.
> >
> > Acked-by: Jingoo Han <jg1.han@samsung.com>
> 
> Ok, if you don't mind I can take it through arm-soc for 3.11 with your ack then. 

Hi Olof Johansson,

Sure, no problem.
If you take it through arm-soc for 3.11 with my ACK, it will be good.
Thank you for caring this. :)

Best regards,
Jingoo Han


