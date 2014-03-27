Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaC0BEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 21:04:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8766 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbaC0BEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 21:04:39 -0400
X-AuditID: cbfee68e-b7f566d000002344-fa-53337926c323
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bryan Wu'" <cooloney@gmail.com>,
        "'Alexandre Courbot'" <gnurou@gmail.com>
Cc: "'Alexandre Courbot'" <acourbot@nvidia.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-pwm@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
 <CAAVeFuKE163O3Kcdy-WCCEesJMCQ-fcLe8Op5f=VE7ZovFptqA@mail.gmail.com>
 <CAK5ve-K7-Qk-VX33ZMWh3WEYOQND_o_TG6Hk28Y7r8dVgVtg9A@mail.gmail.com>
In-reply-to: <CAK5ve-K7-Qk-VX33ZMWh3WEYOQND_o_TG6Hk28Y7r8dVgVtg9A@mail.gmail.com>
Subject: Re: [PATCH 0/2] pwm-backlight: switch to gpiod interface (part 1)
Date: Thu, 27 Mar 2014 10:04:37 +0900
Message-id: <000801cf4958$8678ff20$936afd60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9JUMzYR6HZIXU3Qn2zpRa4gGRAEwAB1tZQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zA121SuNgg1ttHBbfH55itZi07gCT
	xdGdE5kszr16xGJxeeElVoveBVfZLDbP/8NocXnXHDaLu3dXMVr83DWPxYHL4++qF8weO2fd
	ZffobX7H5tG3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZve19bAUPeSqOn7/M3MDYytXFyMkh
	IWAisad7JSuELSZx4d56ti5GLg4hgWWMEq1b/jLDFF2Zs5wVIjGdUeLvpOUsEM5vRonmzS+Y
	QKrYBNQkvnw5zA5iiwh4Sxw438oMUsQscIRJonXWDai5Fxkl1v1eAraQUyBYoqPrG9gOYQEv
	iVX7voN1swioSpy/8okRxOYVsJWY+70TyhaU+DH5HguIzSygJbF+53EmCFteYvOat0BzOIBu
	VZd49FcX4ggjiVNf37BClIhI7HvxjhHkBgmBVg6Jq9duM0HsEpD4NvkQC0SvrMSmA1AvS0oc
	XHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRES4X07
	GG8esD7EmAy0fiKzlGhyPjBB5JXEGxqbGVmYmpgaG5lbmpEmrCTOu+hhUpCQQHpiSWp2ampB
	alF8UWlOavEhRiYOTqkGRgdj+a1zsg6ejjnLc3J/j8WpqWsjf13+oVrDy2nU9rAyJPPvr+Vm
	X5UeW89OypTYuLpq8/HtNVqnDFw83t2eF2nx99ZfscO5tWcSppyQ2N5vWNm0eF7Kouyrmql/
	53bJF24Vm7RI6CTj5RtrizYdu7p6W7ybb+uuaRMOp9+r4XAr41vScsA+v1iJpTgj0VCLuag4
	EQASZfdUBgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jQV21SuNgg59rmC2+PzzFajFp3QEm
	i6M7JzJZnHv1iMXi8sJLrBa9C66yWWye/4fR4vKuOWwWd++uYrT4uWseiwOXx99VL5g9ds66
	y+7R2/yOzaNvyypGj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyV
	FPISc1NtlVx8AnTdMnOAzlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYx
	ZvS297EVPOSpOH7+MnMDYytXFyMnh4SAicSVOctZIWwxiQv31rN1MXJxCAlMZ5T4O2k5C4Tz
	m1GiefMLJpAqNgE1iS9fDrOD2CIC3hIHzrcygxQxCxxhkmiddQOq/SKjxLrfS8DmcgoES3R0
	fWMGsYUFvCRW7fsO1s0ioCpx/sonRhCbV8BWYu73TihbUOLH5HssIDazgJbE+p3HmSBseYnN
	a94CzeEAulVd4tFfXYgjjCROfX3DClEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1
	ILmgOCk911CvODG3uDQvXS85P3cTIzh9PJPawbiyweIQowAHoxIP7477RsFCrIllxZW5hxgl
	OJiVRHjbio2DhXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmNrySuINjU3MjCyNzCyMTMzN
	SRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHR+8PFPaeNNDv2ludzN1k6bXgflj+nyTn8
	0invj7vMt+7UWaLumO/z2LP8e2W8eUPgEqs/mT+u77rvzCmSbO3bai1ycfs3qRdeR1NXfZT8
	+n7ri6uL5W+qKp0xfMDeZqlX+qP/4pL++Zy/axx/fXx4QvbNd64z82feqDXL/r/1Jd/8nn6l
	SdpWSizFGYmGWsxFxYkAD2NRjmMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 27, 2014 9:09 AM, Bryan Wu wrote:
> On Tue, Mar 25, 2014 at 10:01 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> > Ping Thierry, can you have a look at this series? It is quite similar
> > to the same change you merged for panel-simple (although I cannot see
> > it in -next neither).
> >
> 
> I think Jingoo can help to review this as well. Jingoo, can you help
> to review. Actually it looks good to me.

Sorry, I cannot review this pwm-backlight code, I don't have
knowledge about pwm-backlight and gpiod. I think that Thierry
will review this correctly.

Best regards,
Jingoo Han

> 
> -Bryan
> 
> > On Thu, Feb 27, 2014 at 2:53 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> >> These two patches initiate the switch of the pwm-backlight driver to
> >> the gpiod GPIO interface, as it considerably simplifies the code.
> >>
> >> For compatibility with current users of the driver, it is still possible
> >> to pass the enable GPIO number as platform data. Two platforms are still
> >> relying on this feature (pxa/palmtc and shmobile/armadillo800eva) which
> >> will be removed as soon as its last users are switched to GPIO mapping
> >> tables.
> >>
> >> Alexandre Courbot (2):
> >>   ARM: SAMSUNG: remove gpio flags in dev-backlight
> >>   pwm-backlight: switch to gpiod interface
> >>
> >>  arch/arm/plat-samsung/dev-backlight.c |  2 -
> >>  drivers/video/backlight/pwm_bl.c      | 72 +++++++++++++++--------------------
> >>  include/linux/pwm_backlight.h         |  5 +--
> >>  3 files changed, 32 insertions(+), 47 deletions(-)
> >>
> >> --
> >> 1.9.0

