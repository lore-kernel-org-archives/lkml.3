Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3BDGlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:41:09 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19145 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3BDGlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:41:07 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-fc-510f5800ac33
From: "myungjoo.ham" <myungjoo.ham@samsung.com>
To: "'Abhilash Kesavan'" <kesavan.abhilash@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, rjw@sisk.pl, jhbird.choi@samsung.com
References: <1357733199-17206-4-git-send-email-a.kesavan@samsung.com>
 <1358515490-7565-1-git-send-email-a.kesavan@samsung.com>
 <CAM4voakyRiC6nvNv63nK3H3T168MjP-JevbCuksoKbpT=HQqJw@mail.gmail.com>
In-reply-to: <CAM4voakyRiC6nvNv63nK3H3T168MjP-JevbCuksoKbpT=HQqJw@mail.gmail.com>
Subject: RE: [PATCH v4 4/4] PM: Devfreq: Add Exynos5-bus devfreq driver for
 Exynos5250
Date: Mon, 04 Feb 2013 15:41:04 +0900
Message-id: <006201ce02a2$9ae72480$d0b56d80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQEJXmD3TnEBegD0FDGA0t1VCYzeUAIecBIwAqUFv6qZzGx9YA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zHV2GCP5Ag2unLC0u75rDZvG59wij
	A5PH501yAYxRXDYpqTmZZalF+nYJXBk9uy+wFZyQq1g7ex9LA+MUyS5GTg4JAROJxbPWs0LY
	YhIX7q1n62Lk4hASWMYosWLDRUaYom/HFjNDJBYxSux80M0K4fxmlPg0eQoTSBWbgL7Enmu/
	GEESIgItjBIX5m5jAUkwCzhLvNk0kxGi4zijxJLZHewgCU6BYIm+v8vAlgsLREhsPtoJ1sAi
	oCrxaudisBpeAUuJzwv/s0DYghI/Jt+DGqolsX7ncSYIW15i85q3zBC3KkjsOPsa7G4RASeJ
	mbeOMkLUiEjse/EO7AgJgWXsEmfm72OGWCYg8W3yIaChHEAJWYlNB6DmSEocXHGDZQKjxCwk
	q2chWT0LyepZSFYsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRESa1I7GFc2WBxiFOBg
	VOLhZfjFFyjEmlhWXJl7iFGCg1lJhPeqEVCINyWxsiq1KD++qDQntfgQYzLQsROZpUST84Fp
	IK8k3tDYwNjQ0NLQzNTS1IA0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1MFYYLZ+h8Pry
	fPVje5jP7WvhWe+x5a1ve+rerwePCXpvreiwY788WX/vsk0yXqJM/lPzN6knT/m2t+jGPunY
	A8FvLjNKi29u8VJp3Trph4VWwWOXGUu/7n+TldzarGkkzjI9pM8xYHnv778zriYYB/BllUnE
	1305mNyydofowfdf22UalizVuqvEUpyRaKjFXFScCACmehFx+QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAV2GCP5Agw+vDCwu75rDZvG59wij
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZPbsvsBWckKtY
	O3sfSwPjFMkuRk4OCQETiW/HFjND2GISF+6tZ+ti5OIQEljEKLHzQTcrhPObUeLT5ClMIFVs
	AvoSe679YgRJiAi0MEpcmLuNBSTBLOAs8WbTTEaIjuOMEktmd7CDJDgFgiX6/i5jBbGFBSIk
	Nh/tBGtgEVCVeLVzMVgNr4ClxOeF/1kgbEGJH5PvQQ3Vkli/8zgThC0vsXnNW6hbFSR2nH3N
	CGKLCDhJzLx1lBGiRkRi34t3jBMYhWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFi
	bnFpXrpecn7uJkZwJD+T2sG4ssHiEKMAB6MSDy/DL75AIdbEsuLK3EOMEhzMSiK8V42AQrwp
	iZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTDJ5JfGGxiZmRpZGZsYm5sbGpAkrifMynnoSICSQ
	nliSmp2aWpBaBLOFiYNTqoHR1Fix44DyORYd06+Wsp5ZEvpvvLsqVY4t+rWXT8e13s3R7kiR
	UL+14szaN9X7v5/RbNNhNvRmcj75NsGji2POsfqaz/280nOb6rnuPwz5FHWg8mD2iesy3Tuj
	kkKD1mxNE5b6MCVlx03lB9oTwmZ5yP2b9KZcW283RzTnU+kJSs71+qX6y5VYijMSDbWYi4oT
	Aai5KgwoAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> -----Original Message-----
> From: Abhilash Kesavan [mailto:kesavan.abhilash@gmail.com] 
> Sent: Monday, February 04, 2013 12:48 AM
> To: myungjoo.ham@samsung.com; linux-kernel@vger.kernel.org;
linux-pm@vger.kernel.org; kgene.kim@samsung.com
> Cc: kyungmin.park@samsung.com; rjw@sisk.pl; jhbird.choi@samsung.com
> Subject: Re: [PATCH v4 4/4] PM: Devfreq: Add Exynos5-bus devfreq driver
for Exynos5250
> 
> Hi Myungjoo,
> 
> Any comments on this patch ?
> 
> Abhilash
> 


Sorry for being late.

One concern is that I cannot apply Patch 1/4 directly as the .dts file isn't
available to me.
Do you intend to apply that patch to another tree and apply the other three
to devfreq tree?

Another is the location of exynos_ppmu.h.
Who is going to refer exynos_ppmu.h?
If Exynos devfreq drivers are the only files to refer, wouldn't it be better
located at drivers/devfreq/exynos/ ?

Or do you intend to let someone else (drivers located not in
drivers/devfreq) access exynos-ppmu?
(If so, who's going to be? and that means we are going to have
include/linux/devfreq/, I don't think it'd be appropriate to populate
include/linux with device driver specific headers)



And, there are errors (we do not have __devinit/__devexit anymore):

  CC      drivers/devfreq/exynos/exynos5_bus.o
drivers/devfreq/exynos/exynos5_bus.c:315:18: error: expected =, ,, ;, asm or
__attribute__ before int
drivers/devfreq/exynos/exynos5_bus.c:430:18: error: expected =, ,, ;, asm or
__attribute__ before int
drivers/devfreq/exynos/exynos5_bus.c:462:11: error:
exynos5_busfreq_int_probe undeclared here (not in a function)
drivers/devfreq/exynos/exynos5_bus.c:463:2: error: implicit declaration of
function __devexit_p [-Werror=implicit-function-declaration]
drivers/devfreq/exynos/exynos5_bus.c:463:24: error:
exynos5_busfreq_int_remove undeclared here (not in a function)
drivers/devfreq/exynos/exynos5_bus.c:235:35: warning:
exynos5_devfreq_int_profile defined but not used [-Wunused-variable]
drivers/devfreq/exynos/exynos5_bus.c:243:12: warning:
exynos5250_init_int_tables defined but not used [-Wunused-function]
drivers/devfreq/exynos/exynos5_bus.c:259:12: warning:
exynos5_busfreq_int_pm_notifier_event defined but not used
[-Wunused-function]
cc1: some warnings being treated as errors



Cheers,
MyungJoo.


> On Fri, Jan 18, 2013 at 6:54 PM, Abhilash Kesavan <a.kesavan@samsung.com>
wrote:
> > Exynos5-bus device devfreq driver monitors PPMU counters and adjusts 
> > operating frequencies and voltages with OPP. ASV should be used to 
> > provide appropriate voltages as per the speed group of the SoC rather 
> > than using a constant 1.025V.
> >
> > Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> > Cc: Jonghwan Choi <jhbird.choi@samsung.com>
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > ---
> > Changes since RFC v1:
> > * Moved the Exynos5 PPMU driver to machine specific directory
> > * Migrated to the PM QOS framework
> > Changes since v2:
> > * Moved the PPMU driver to drivers/devfreq/exynos
> > * Fixed whitespace, commenting, empty lines in PPMU driver Changes 
> > since v3:
> > * Removed the custom devfreq monitor and PPMU polling function
> > * Moved exynos5 PPMU access functions to the devfreq driver
> >
> >  drivers/devfreq/Kconfig              |   10 +
> >  drivers/devfreq/Makefile             |    1 +
> >  drivers/devfreq/exynos/Makefile      |    1 +
> >  drivers/devfreq/exynos/exynos5_bus.c |  502
++++++++++++++++++++++++++++++++++
> >  drivers/devfreq/exynos/exynos_ppmu.c |   55 ++++
> >  include/linux/exynos_ppmu.h          |   79 ++++++
> >  6 files changed, 648 insertions(+), 0 deletions(-)  create mode 
> > 100644 drivers/devfreq/exynos/exynos5_bus.c
> >  create mode 100644 drivers/devfreq/exynos/exynos_ppmu.c
> >  create mode 100644 include/linux/exynos_ppmu.h
> >

