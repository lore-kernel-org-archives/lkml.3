Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaFQDrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:47:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36053 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbaFQDro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:47:44 -0400
X-AuditID: cbfee68f-b7fef6d000003970-e3-539fba5e44d8
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        yg1004.jang@samsung.com, vikas.sajjan@samsung.com
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
 <1399704998-13321-3-git-send-email-pankaj.dubey@samsung.com>
 <5396EFFB.3040704@samsung.com>
In-reply-to: <5396EFFB.3040704@samsung.com>
Subject: RE: [PATCH v4 02/11] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
Date: Tue, 17 Jun 2014 09:18:25 +0530
Message-id: <000101cf89de$ffbb1730$ff314590$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFbr3MzJH2VQYc81U++V3sC+P5mXwIaMGxdAch7DtOcPUklIA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWyRsSkWjdu1/xgg+7XGhbLJt1ls+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wW62e8ZrG4+Ww7kwOHR0tzD5vH5iX1Hn1bVjF6fN4kF8AS
	xWWTkpqTWZZapG+XwJXxb+ZL1oJWjoqvB98wNzBuZeti5OSQEDCRePHoOpQtJnHh3nowW0hg
	KaPEr0lSMDVP5q4DinMBxRcxSvxeMpMJwvnLKHF85R9WkCo2AV2JJ+/nMoMkRAT6GSVebv0B
	lmAWqJFY0LmZBaJjBaPEzN69jCAJTgFtiU+nrrOA2MICmRLzLu4CauDgYBFQldj9Ix4kzCtg
	KfHtzStGCFtQ4sfkeywQM7Uk1u88zgRhy0tsXvOWGeJUBYkdZ1+D1YsIOElMOrmUGaJGXGLS
	g4fsIDdICLxkl/jzfT/YnywCAhLfJh9iAdkrISArsekA1BxJiYMrbrBMYJSYhWT1LCSrZyFZ
	PQvJigWMLKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAqP39L9n/TsY7x6wPsSYDLR+IrOU
	aHI+MPrzSuINjc2MLExNTI2NzC3NSBNWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwen
	VAMj85Ka88qqW5gFFis5L9qxStH0S2ZjxTHTg90RcW1qAsEr1F8UXZLtl9P/57gorDPqVXzZ
	M/8GRl3DQ8IpR7wvqb+/e9jxp/6uGwZlX25Nmj7dXcr72uLlOs8N3y8sb5d5LB88g79izyyN
	4n1r3k389W/j7rJq1l2PjZ5MvCr5TW8d48HNx7Y+UmIpzkg01GIuKk4EAH6lLZz0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd24XfODDS5PV7BYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WD/jNYvFzWfbmRw4PFqae9g8Ni+p9+jbsorR4/MmuQCW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGf9mvmQtaOWo+HrwDXMD41a2
	LkZODgkBE4knc9dB2WISF+6tB7K5OIQEFjFK/F4ykwnC+csocXzlH1aQKjYBXYkn7+cygyRE
	BPoZJV5u/QGWYBaokVjQuZkFomMFo8TM3r2MIAlOAW2JT6eus4DYwgKZEvMu7gJq4OBgEVCV
	2P0jHiTMK2Ap8e3NK0YIW1Dix+R7LBAztSTW7zzOBGHLS2xe85YZ4lQFiR1nX4PViwg4SUw6
	uZQZokZcYtKDh+wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcHJ4Jr2DcVWDxSFGAQ5GJR7eB7Lzg4VYE8uKK3MPMUpwMCuJ8HKZA4V4UxIrq1KL8uOL
	SnNSiw8xJgM9OpFZSjQ5H5i48kriDY1NzE2NTS1NLEzMLEkTVhLnPdhqHSgkkJ5YkpqdmlqQ
	WgSzhYmDU6qBUfRnyXmpnM5ZEov/9NkfOpH+UaNH/tAH9jyXsEfezZsavnFFy1vPaTn8ZtWE
	td4rQ55X9tRdOWrbPM1SLUadf9m2O1ram6TTzbnDrHLWleZzmIq3HPLadudhVWfHzItX7K13
	VMs/Xq+jsTXFIsgm4sTVqkMebT5HTTtb1gmxrYyRmvN/CccOJZbijERDLeai4kQAdngByVID	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

> -----Original Message-----
> 
> Hi Pankaj,
> 
> On 10.05.2014 08:56, Pankaj Dubey wrote:
> > As exynos_cpuidle_init and exynos_cpufreq_init function have just one
> > lines of code for registering platform devices. We can move these
> > lines to exynos_dt_machine_init and delete exynos_cpuidle_init and
> > exynos_cpufreq_init function. This will help in reducing lines of code
> > in exynos.c, making it more cleaner.
> >
> > Suggested-by: Tomasz Figa <t.figa@samsung.com>
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > ---
> >  arch/arm/mach-exynos/exynos.c |   19 ++++---------------
> >  1 file changed, 4 insertions(+), 15 deletions(-)
> >
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 

Thanks for review.

> Btw. This and other simple clean-up patches from this series could be
applied
> separately, without re-spinning them every time with this series.
> 

OK, I will separate cleanup patches.

> Best regards,
> Tomasz

Thanks,
Pankaj Dubey


