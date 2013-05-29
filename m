Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab3E2AHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:07:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10651 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3E2AHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:07:11 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-01-51a546ad8401
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>,
        "'Tushar Behera'" <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Patch Tracking'" <patches@linaro.org>
References: <1368168599-28507-1-git-send-email-tushar.behera@linaro.org>
 <CAOesGMjirb0h4kZ1hB9=1JnDV+azTEG=_6RR9v000xbMsvuv2Q@mail.gmail.com>
In-reply-to: <CAOesGMjirb0h4kZ1hB9=1JnDV+azTEG=_6RR9v000xbMsvuv2Q@mail.gmail.com>
Subject: RE: [PATCH] ARM: EXYNOS: Update defconfig for Arndale and Origen board
Date: Wed, 29 May 2013 09:07:09 +0900
Message-id: <17ec01ce5c00$76384e40$62a8eac0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5b+nrEuZPvXurcThqaVC5vRqgd8wABahBA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zA921bksDDZaskbY4u+wgm8Wmx9dY
	LS7vmsNmMeP8PiaLU9c/s1lMOfyFxaL97142B3aP2Q0XWTzuXNvD5rF5Sb3HlRNNrB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZUw4MoWxoIOtYtabNawNjHdYuhg5OCQETCTaP+h0MXICmWISF+6t
	Z+ti5OIQEljGKPH2xQ5GiISJxP7vTUwQiUWMEjeuLWQGSQgJ/GWU6D3ACmKzCWhIHH7/jB3E
	FhEIllg+uYcFpIFZYC+jxOLHL1ghuvsZJQ6ufQ7WwQlU9ejEarAVwgL+ElsvdzGB2CwCqhLf
	904Am8QrYCtx7PoRJghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yQ7yjLvHory7EEUYShxqe
	skKUiEjse/GOEeQGCYGP7BKz+++wQOwSkPg2+RA0KGQlNh1ghvhYUuLgihssExglZiHZPAvJ
	5llINs9CsmIBI8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjJDonbCD8d4B60OMyUDrJzJL
	iSbnA6M/ryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTByc
	Ug2MbhFmxXJSO9xXctfJKSz83jo9Ys98ZzUFW1fpKRcSPvw4ebtjxqblZ9oD5CO/eMxgEGPv
	cVzp1+Cyt26Py47vvB4iWTtrmQ9+bZn8OHLLrDd+U2bWteYlVluobv3KbmLQcna/qSLj7Dd/
	bl65btr58oj9jP+LmNJOCqiwP3m8JeXP46mbEi9xKbEUZyQaajEXFScCAFgtl3L0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd21bksDDS70ilucXXaQzWLT42us
	Fpd3zWGzmHF+H5PFqeuf2SymHP7CYtH+dy+bA7vH7IaLLB53ru1h89i8pN7jyokmVo/Pm+QC
	WKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZMODKFsaCDrWLWmzWsDYx3
	WLoYOTkkBEwk9n9vYoKwxSQu3FvP1sXIxSEksIhR4sa1hcwgCSGBv4wSvQdYQWw2AQ2Jw++f
	sYPYIgLBEssn97CANDAL7GWUWPz4BStEdz+jxMG1z8E6OIGqHp1YzQhiCwv4S2y93AW2jkVA
	VeL73glgk3gFbCWOXT/CBGELSvyYfA/sPGYBLYn1O48zQdjyEpvXvAW6iAPoVHWJR391IY4w
	kjjU8JQVokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66
	XnJ+7iZGcHJ4JrWDcWWDxSFGAQ5GJR5ehl9LAoVYE8uKK3MPMUpwMCuJ8KYKLg0U4k1JrKxK
	LcqPLyrNSS0+xJgM9OhEZinR5Hxg4soriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6Yklq
	dmpqQWoRzBYmDk6pBkZetXWV2941WJ1aJPy2fNN+z3plhUSeKJst5bcKnZQ7g63/Lf/F9Dv9
	ggLjlTzxG9lzDooEHjeSCc89Z23seqZp0tn7bidFHjU+Llqzaq2QkF7D1elS/0OfW1533fWN
	PTuX7Zjtvc+1h7wXNexe4e3qcuGp9LeVPrOf+8izJQhE6Xt7PH8cOlGJpTgj0VCLuag4EQCt
	EfuVUgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> Hi,
> 
> On Thu, May 9, 2013 at 11:49 PM, Tushar Behera <tushar.behera@linaro.org>
> wrote:
> > It updates following drivers for EXYNOS based DT platform.
> >
> > * S5M8767 driver
> > * MAX8997 driver
> > * MMC SDHCI driver
> >
> > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> 
> I didn't see any movement from Kukjin on this, so I have (tentatively)
> applied this together with my base defconfig update to the fixes
> branch of arm-soc. I'll take it out in case he protests, but it's very
> useful since the simplefb driver has landed in 3.10-rc3.
> 
I'm fine on this, so please go ahead with my ack if you want,

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks for your gentle reminder :-)

- Kukjin

