Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3JQXhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:37:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49315 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3JQXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:37:37 -0400
X-AuditID: cbfee691-b7fe06d0000008c4-1b-526074c0e256
From: Kukjin Kim <kgene@kernel.org>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>
References: <1380390554-4400-1-git-send-email-tomasz.figa@gmail.com>
 <3346618.t8I6lVv536@flatron>
In-reply-to: <3346618.t8I6lVv536@flatron>
Subject: RE: [PATCH] ARM: s3c64xx: Select CPU_V6K instead of CPU_V6
Date: Fri, 18 Oct 2013 08:37:34 +0900
Message-id: <1e2901cecb91$db24edd0$916ec970$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7KnicaH7oMlYFFTkKSZTt+jF5LFwA8tsmw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zfd0DJQlBBn/uiFn8nXSM3WLT42us
	Fpd3zWGzmHF+H5PF7cu8Fqeuf2azWLXrD6MDu0dLcw+bx+9fkxg9ds66y+6xeUm9x5UTTawe
	nzfJBbBFcdmkpOZklqUW6dslcGW8vD6ZpeA5e8WaWV/YGxg72LoYOTkkBEwkuqdMYIGwxSQu
	3FsPFhcSWMYosbozA6bm/fOHQHEuoPh0RonPnfeYIJy/jBKHHr8Ccjg42ASUJRqb9EEahAW0
	JBZuaQIbKiLgL3HlxnFGkHpmgS2MEs9/fmCC2JAscXr7fUYQm1NAU2LLrufsEM3OEq/nf2UG
	sVkEVCUWXW0Hq+cVMJT4cXQClC0o8WPyPbAFzEDL1u88zgRhy0tsXvOWGeQeCQF1iUd/dSFu
	MJKYNO0nVLmIxL4X78DukRD4yy7xYv0tRohdAhLfJh9igeiVldh0gBnieUmJgytusExglJyF
	ZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzFCYnviDsb7B6wPMSYD
	rZ/ILCWanA9MDXkl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYf
	YmTi4JRqYFx8JqzfSiHDme2lCJtK0LX7a1Q1NoTmzF6/ql7j3qXXrJ1XPrEsCHLKV4327Lik
	Jvl+ul5dxRLevLsC669GxPpJTpcNm2Mc67HlwJf51zzqd7CdbLu74LtEnmOAdOq5Sc1Tg5n/
	hfonecudu+zX1viCmXfri6mtumrMrFJtR/i91v04tpfzuhJLcUaioRZzUXEiAH3C+s0DAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jQd0DJQlBBrNbhSz+TjrGbrHp8TVW
	i8u75rBZzDi/j8ni9mVei1PXP7NZrNr1h9GB3aOluYfN4/evSYweO2fdZffYvKTe48qJJlaP
	z5vkAtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmvLw+maXgOXvFmllf
	2BsYO9i6GDk5JARMJN4/fwhli0lcuLceyObiEBKYzijxufMeE4Tzl1Hi0ONXQA4HB5uAskRj
	kz5Ig7CAlsTCLU0sILaIgL/ElRvHGUHqmQW2MEo8//mBCSQhJJAscXr7fUYQm1NAU2LLrufs
	EM3OEq/nf2UGsVkEVCUWXW0Hq+cVMJT4cXQClC0o8WPyPbAFzEDL1u88zgRhy0tsXvOWGeQe
	CQF1iUd/dSFuMJKYNO0nVLmIxL4X7xgnMArPQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2M4NTxTHoH46oGi0OMAhyMSjy8B77FBwmxJpYVV+YeYpTgYFYS4W0V
	TggS4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgWssriTc0NjEzsjQyszAyMTcnTVhJnPdg
	q3WgkEB6YklqdmpqQWoRzBYmDk6pBkax6d9v7r1yLzTULHujw1pnpcsfn8n3TlpVEJHUqzKF
	peDAz/qfuRGTH271Flpz5UVx65lkrS9zD1dkeDNOfPj1thRXd0QWlwnvhC9paU8b6nr873yZ
	+D1DTphtpYKzQMifJW6+n6Mt73jcrf5fe1s5q//aSru68tbNa2Rfryx8+16E8VwXv50SS3FG
	oqEWc1FxIgAGg4ZdYQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Hi Kukjin,
> 
> On Saturday 28 of September 2013 19:49:14 Tomasz Figa wrote:
> > All S3C64XX SoCs come with ARM1176JZF-s core, which fully supports
> > ARMv6K extensions. This patch lets the kernel use them on S3C6410 by
> > adding selection of CPU_V6K to ARCH_S3C64XX.
> >
> > Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> > ---
> >  arch/arm/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> What do you think about this patch?
> 
Yeah, ARM1176JZF-s is correct. Applied.

Thanks,
Kukjin

> Best regards,
> Tomasz
> 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index b766dad..3a41bbb 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -728,7 +728,7 @@ config ARCH_S3C64XX
> >  	select CLKDEV_LOOKUP
> >  	select CLKSRC_SAMSUNG_PWM
> >  	select COMMON_CLK
> > -	select CPU_V6
> > +	select CPU_V6K
> >  	select GENERIC_CLOCKEVENTS
> >  	select GPIO_SAMSUNG
> >  	select HAVE_CLK

