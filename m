Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaHAOS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:18:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12345 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAOS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:18:57 -0400
X-AuditID: cbfee690-b7f526d000003627-cd-53dba1ce065b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Olof Johansson'" <olof@lixom.net>,
        arm@kernel.org
References: <1406883097-14157-1-git-send-email-tomasz.figa@gmail.com>
 <1910401.THJm9YLBl0@amdc1032>
In-reply-to: <1910401.THJm9YLBl0@amdc1032>
Subject: RE: [FIX][RESEND PATCH v3] ARM: EXYNOS: Fix suspend/resume sequences
Date: Fri, 01 Aug 2014 23:18:53 +0900
Message-id: <081101cfad93$8615d810$92418830$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJSoNHT2To9pv5qobpsT1YRV0ZVxgH9zPqDmqX1M2A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zA91zC28HGzycx2xx7MsWNou/k46x
	W2ycsZ7VYtPja6wWl3fNYbOYcX4fk8XaI3fZLU5d/8xmsX7GaxaLVbv+MDpwefz+NYnRY+es
	u+wem1Z1snlsXlLvceVEE6tH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZcz+up2x4LdoxdaP
	PSwNjKcEuxg5OSQETCQuLPnJDGGLSVy4t56ti5GLQ0hgGaPE4am/mGCKnu7qYIVILGKUOHB7
	LyOE85dRYkPnNRaQKjYBDYnD75+xg9giAskSszo6GUFsZoFpTBLvPxWC2EICqRKH15wBinNw
	cApoSdxdWA4SFhbwldg8fy/YFSwCqhILjy5gBbF5BSwlHp1rZoawBSV+TL7HAjFSS2L9zuNM
	ELa8xOY1b6E+UJDYcfY1I8QJVhIHD65kh6gRkdj34h0jRE0vh8TKVn+IXQIS3yYfYgE5R0JA
	VmLTAagxkhIHV9xgmcAoMQvJ5llINs9CsnkWkg0LGFlWMYqmFiQXFCelF5noFSfmFpfmpesl
	5+duYoRE+4QdjPcOWB9iTAZaP5FZSjQ5H5gs8kriDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQk
	kJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMZxr+//2+LJJvx5cLoj+2rxa1voRW0HEsdpfO/8m
	P/dlOdmo4JtX+Nnb4Lvw9WkrVgVPjbEQSrKwNjRQMCqUqN4v/jP+95oNT+S4dFNmuG/cvf9t
	zYNJqjNe3FV1yV6vfevHpR8Gh/l4VLvEfm3/LPVONFnUqb0qpkkpcPvp6Ux5Z6bt1NhgqMRS
	nJFoqMVcVJwIAOHccPcMAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd2zC28HG9w+Y21x7MsWNou/k46x
	W2ycsZ7VYtPja6wWl3fNYbOYcX4fk8XaI3fZLU5d/8xmsX7GaxaLVbv+MDpwefz+NYnRY+es
	u+wem1Z1snlsXlLvceVEE6tH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yY/XU7Y8Fv0YqtH3tYGhhPCXYxcnJICJhIPN3VwQphi0lcuLeerYuRi0NI
	YBGjxIHbexkhnL+MEhs6r7GAVLEJaEgcfv+MHcQWEUiWmNXRyQhiMwtMY5J4/6kQxBYSSJU4
	vOYMUJyDg1NAS+LuwnKQsLCAr8Tm+XuZQWwWAVWJhUcXgC3mFbCUeHSumRnCFpT4MfkeC8RI
	LYn1O48zQdjyEpvXvGWGOFRBYsfZ14wQJ1hJHDy4kh2iRkRi34t3jBMYhWYhGTULyahZSEbN
	QtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwMnkmvYNxVYPFIUYBDkYlHl6H0FvB
	QqyJZcWVuYcYJTiYlUR4zeffDhbiTUmsrEotyo8vKs1JLT7EaAr06URmKdHkfGCiyyuJNzQ2
	MTOyNDKzMDIxN1cS5z3Yah0oJJCeWJKanZpakFoE08fEwSnVwMj+olp8OdMNRed1kv+Eiw+E
	hMvJVG86vD5e/pDh12kMX4+3m1wtEIuI7JtmYvUg+5DXl8cRnAmtsj0+Ifp1a8RS1f+o52Qt
	2Pe/rzh53wExA49JvUlB3ntfPN+UPbfuttM96cm5z1i/Vu1+7rl149tdERZKcdvOyjO5RFuo
	LGgOetFcq5KWq8RSnJFoqMVcVJwIAIOGUUI8AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
Hi,

> On Friday, August 01, 2014 10:51:37 AM Tomasz Figa wrote:
> > From: Tomasz Figa <t.figa@samsung.com>
> >
> > Due to recent consolidation of Exynos suspend and cpuidle code, some
> > parts of suspend and resume sequences are executed two times, once from
> > exynos_pm_syscore_ops and then from exynos_cpu_pm_notifier() and thus it
> > breaks suspend, at least on Exynos4-based boards. In addition, simple
> > core power down from a cpuidle driver could, in case of CPU 0 could
> > result in calling functions that are specific to suspend and deeper idle
> > states.
> >
> > This patch fixes the issue by moving those operations outside the CPU PM
> > notifier into suspend and AFTR code paths. This leads to a bit of code
> > duplication, but allows additional code simplification, so in the end
> > more code is removed than added.
> >
> > Fixes: 85f9f90808b4 ("ARM: EXYNOS: Use the cpu_pm notifier for pm")
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Olof Johansson <olof@lixom.net>
> > Cc: arm@kernel.org
> > Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> >  arch/arm/mach-exynos/pm.c        | 164 ++++++++++++++++++---------------------
> >  drivers/cpuidle/cpuidle-exynos.c |  25 +-----
> >  2 files changed, 80 insertions(+), 109 deletions(-)
> >
> > This is resend of a regression fix sent more than two weeks ago (July, 15;
> > [1]), without any response from respective maintainers. It fixes
> > a significant regression breaking suspend/resume on Exynos4-based systems.
> >
> > I know we already have -rc7, but this patch in its first iteration was
> > sent more than a month ago (June, 24; [2]) and it changed only for
> > convenience of authors of further patches, to either avoid conflicts ([3])
> > or reduce the need of changes to support more functionality later (as
> > discussed in [4]). However it should have had priority over clean-up or
> > functional patches, which was apparently not the case.
> 
> This is not quite right, your initial version needed to be changed also
> because of potential problems (https://lkml.org/lkml/2014/7/15/206).
> 
Yeah...hmm...maybe it should be updated in 3.17...

> However the current version (from two weeks ago) is fine and IMO still
> should be merged as a _regression_ fix for v3.16 (despite not being
> a tiny patch).
> 
Agreed. OK.

> Also FWIW:
> 
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> 
Acked-by: Kukjin Kim <kgene.kim@samsung.com>

@Olof,

It's true this is a regression for v3.16 and I couldn't take this before
because of some dependencies...so I'd like to ask you to take for v3.16 even
though it's late and big...

Thanks,
Kukjin

