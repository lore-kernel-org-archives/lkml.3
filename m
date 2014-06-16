Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbaFPSry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:47:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35473 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859AbaFPSrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:47:49 -0400
Date: Mon, 16 Jun 2014 14:47:46 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Doug Anderson <dianders@chromium.org>
cc: Kevin Hilman <khilman@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tushar Behera <trblinux@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: EXYNOS: mcpm: Don't rely on firmware's
 secondary_cpu_start
In-Reply-To: <CAD=FV=XYBSkx_3jzZ2G=WuEYweiejna7KionneqUkEVPx3_E-w@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1406161447190.16842@knanqh.ubzr>
References: <1402090985-8061-1-git-send-email-dianders@chromium.org> <1402096465-13218-1-git-send-email-dianders@chromium.org> <7htx7uq7k1.fsf@paris.lan> <CAL1qeaGv+hBCr8oqs-E2j_Qh0Z=ZTVEaM-gdyu286Snu4otbMA@mail.gmail.com> <alpine.LFD.2.11.1406091617181.25775@knanqh.ubzr>
 <CAGa+x87puSoPftG6ddGTVtxOOxoUg_dLmMmZUHm-j6pjFuhr=g@mail.gmail.com> <alpine.LFD.2.11.1406091649290.25775@knanqh.ubzr> <CAD=FV=XYBSkx_3jzZ2G=WuEYweiejna7KionneqUkEVPx3_E-w@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Doug Anderson wrote:

> Nicolas,
> 
> On Mon, Jun 9, 2014 at 1:55 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Mon, 9 Jun 2014, Kevin Hilman wrote:
> >
> >> On Mon, Jun 9, 2014 at 1:22 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> >> > On Mon, 9 Jun 2014, Andrew Bresticker wrote:
> >> >
> >> >> > [1] While waiting for the forth-coming patch from Andrew to enable the
> >> >> >     CCI port for the boot cluster), I do this from u-boot before starting
> >> >> >     the kernel (based on earlier email from Doug):
> >> >> >
> >> >> >     mw.l 10d25000 3  # Enable CCI from U-Boot
> >> >>
> >> >> From the other thread, it sounds like Nicolas wants enabling of the
> >> >> boot cluster's CCI port to be done unconditionally for all MCPM
> >> >> platforms.  Nicolas, are you preparing a patch for this or should I?
> >> >
> >> > I would like confirmation this indeed solves your problem first before I
> >> > go ahead with it.
> >>
> >> FYI... I confirmed on the other thread.  It works on the Chromebook2.
> >
> > OK I'll clean it up for mainline.
> 
> I just wanted to double-check that this is still on your list of
> things to do.  If not then please let us know!  :)

It is.


Nicolas
