Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbaEFE7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:59:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13691 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaEFE7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:59:07 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-a9-53686c190344
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Alexandre Courbot'" <gnurou@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Thierry Reding'" <thierry.reding@gmail.com>
Cc: "'Alexandre Courbot'" <acourbot@nvidia.com>,
        "'Bryan Wu'" <cooloney@gmail.com>, linux-pwm@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
 <1393480414-19473-2-git-send-email-acourbot@nvidia.com>
 <CAAVeFu+XUzZ7ozMOcp6A-gZJ9o8DZFrdh1j4LvCQtoTcu=PP1g@mail.gmail.com>
 <000701cf54a2$7c1379c0$743a6d40$%han@samsung.com>
 <CAAVeFuKJnSk2XSsMZZKMfyabzJ5CYdqWdE91H5uHiYFC1r6HxA@mail.gmail.com>
 <CAAVeFuKeT9+m_yFc8ihfc_p5W--dCm0-eO+ccjv99WOwurAirQ@mail.gmail.com>
In-reply-to: <CAAVeFuKeT9+m_yFc8ihfc_p5W--dCm0-eO+ccjv99WOwurAirQ@mail.gmail.com>
Subject: RE: [PATCH 1/2] ARM: SAMSUNG: remove gpio flags in dev-backlight
Date: Tue, 06 May 2014 13:59:05 +0900
Message-id: <0fa001cf68e7$e7c4c440$b74e4cc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIdvoULnfVj2yfw4NbVIN1da9gVQQJHdzxCApSx5cgB1HITugJQGPi7Akwv5zGaO+tPcA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zA13JnIxgg2VnLC2+PzzFajFp3QEm
	i6M7JzJZnHv1iMXi8sJLrBab5/9htLi8aw6bxd27qxgtfu6ax+LA6fF31Qtmj52z7rJ79Da/
	Y/Po27KK0ePzJrkA1igum5TUnMyy1CJ9uwSujGlX9rMX3OGquL9nF1sD42aOLkZODgkBE4nz
	P8+wQNhiEhfurWfrYuTiEBJYxiix/eZ6ZpiiC329jBCJRYwSR/e/gqr6yyjRfqIfrIpNQEPi
	8Ptn7CAJEYEFjBJXf35iBXGYBY4ySryf2MMC0dLGLHH15A82kBZOgWCJO923WEFsYQFPiZ2b
	v4HFWQRUJZb/XAJm8wpYSmz6c4AJwhaU+DH5Hti1zALqEpPmLWKGsOUlNq95C3WsgsSOs68Z
	QWwRgQiJLZc3Q9WLSOx78Q7sCQmBRg6J5ct+QC0TkPg2+RBQEQdQQlZi0wGoOZISB1fcYJnA
	KDELyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKExPaEHYz3Dlgf
	YkwGWj+RWUo0OR+YGvJK4g2NzYwsTE1MjY3MLc1IE1YS51V7lBQkJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgbHyn4aKj9lyoe8CD9c3y0dVRG2fqeMgMuE57yndsHdNCtJKQUaKf3lVl1UL
	y/y66r0y6FtNUfT5tLcrxS5PS+5ufiny9jP3laeMVWdV1r1R3C6nqvlahN9o7vNL286IHP3H
	3jZ1T5d3aJPXloAXV9sv7lrM63Wl7bJyh8p3R/0rm64vDha8+V2JpTgj0VCLuag4EQDSmybM
	AwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jAV3JnIxgg+mvTSy+PzzFajFp3QEm
	i6M7JzJZnHv1iMXi8sJLrBab5/9htLi8aw6bxd27qxgtfu6ax+LA6fF31Qtmj52z7rJ79Da/
	Y/Po27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxU
	WyUXnwBdt8wcoIuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnTruxn
	L7jDVXF/zy62BsbNHF2MnBwSAiYSF/p6GSFsMYkL99azdTFycQgJLGKUOLr/FZTzl1Gi/UQ/
	M0gVm4CGxOH3z9hBEiICCxglrv78xAriMAscZZR4P7GHBaKljVni6skfbCAtnALBEne6b7GC
	2MICnhI7N38Di7MIqEos/7kEzOYVsJTY9OcAE4QtKPFj8j0WEJtZQF1i0rxFzBC2vMTmNW+Z
	IY5VkNhx9jXY4SICERJbLm+GqheR2PfiHeMERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRnDieSe1gXNlgcYhRgINRiYf3xMr0YCHWxLLiytxDjBIczEoi
	vP5OGcFCvCmJlVWpRfnxRaU5qcWHGJOBPp3ILCWanA9Mankl8YbGJmZGlkZmFkYm5uakCSuJ
	8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwJiw5uf90Av1rApremyXcLHIuByXcLzB//Z5XaRa
	CtuLou8fz7BM3HjmrI7wkps3NCZu0rE09dN5uY0/KURwQjyX+kWR+lf/fnzaLSK96/bX7YGs
	7j47qk1mqf278+PFq7fLnZ5sviV64Mz+2hy20n891R5r3lrIHtVx+HpIOnKCapfz52UrFXiV
	WIozEg21mIuKEwEwc7YvYAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Courbot wrote:
> 
> On Thu, Apr 10, 2014 at 11:14 PM, Alexandre Courbot <gnurou@gmail.com>
> wrote:
> > On Thu, Apr 10, 2014 at 6:51 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> >> On Thursday, April 10, 2014 1:17 PM, Alexandre Courbot wrote:
> >>>
> >>> Ping, can I have the Samsung folks review and ,aybe even merge this
> >>> patch? enable_gpio_flags is never used in any code, is replaced by
> >>> gpiod, and we would like to remove it altogether from pwm_bl. Thanks!
> >>
> >> OK, I see. It looks good.
> >>
> >> As far as I know, 'enable_gpio_flags' has not been being used
> >> for Samsung platform. So, there will be no side effect,
> >> if 'enable_gpio_flags' is removed from 'arch/arm/plat-samsung'
> >> directory.
> >>
> >> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> >
> > Great, thanks. Ben, Kukjin, could we have your Acked-by?
> >
> > Thierry, if the Samsung maintainers are ok with it, and 2/2 of this
> > series is also ok for you (you merged the same for simple-panel
> > already), can you take both into your tree?
> 
> Last call - could we have a Acked-by from Ben or Kukjin and merge this
> through Thierry's tree? Otherwise I will just have to drop this
> series, which would be sad.

Very sorry for late response. I missed... :(

Looks good to me, so please go ahead with my ack.

Thanks,
Kukjin

