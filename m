Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaB0HAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 02:00:36 -0500
Received: from gloria.sntech.de ([95.129.55.99]:53422 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaB0HAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 02:00:35 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 3/3] ARM: S3C24XX: select COMMON_CLK_SAMSUNG for S3C24XX
Date: Thu, 27 Feb 2014 07:59:49 +0100
Message-ID: <17644043.UHm3oirvbC@phil>
User-Agent: KMail/4.11.5 (Linux/3.12-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <530E996A.9080208@samsung.com>
References: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com> <20140227001620.12081.28601@quantum> <530E996A.9080208@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 27. Februar 2014, 10:48:26 schrieb Pankaj Dubey:
> On 02/27/2014 09:16 AM, Mike Turquette wrote:
> > Quoting Pankaj Dubey (2014-02-25 21:24:07)
> > 
> >> CC: Ben Dooks <ben-linux@fluff.org>
> >> CC: Kukjin Kim <kgene.kim@samsung.com>
> >> CC: Russell King <linux@arm.linux.org.uk>
> >> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> >> ---
> >> 
> >>   arch/arm/mach-s3c24xx/Kconfig |    3 +++
> >>   1 file changed, 3 insertions(+)
> >> 
> >> diff --git a/arch/arm/mach-s3c24xx/Kconfig
> >> b/arch/arm/mach-s3c24xx/Kconfig
> >> index 80373da..5cf82a1 100644
> >> --- a/arch/arm/mach-s3c24xx/Kconfig
> >> +++ b/arch/arm/mach-s3c24xx/Kconfig
> >> @@ -40,6 +40,7 @@ config CPU_S3C2410
> >> 
> >>   config CPU_S3C2412
> >>   
> >>          bool "SAMSUNG S3C2412"
> >>          select COMMON_CLK
> >> 
> >> +       select COMMON_CLK_SAMSUNG
> > 
> > I guess this depends on Heiko's "[PATCH 00/12] ARM: S3C24XX: convert
> > s3c2410, s3c2440 s3c2442 to common clock framework" series?
> > 
> > Regards,
> > Mike
> 
> Yes, this series is based on latest kgene/for-next branch where Heiko's
> series is merged.

Just to clarify, converted are the s3c2416/s3c2443 (first series) and s3c2412 
(second series), because the clockout for s3c2410 etc seems to need a bit more 
work. I've just moved two comon patches (shared plls and a platform change) 
from the s3c2410,et-all series into the s3c2412 one.

Both of these series are merged in kgenes tree as mentioned. And at this point 
I'm not sure if I will have the time to respin the s3c2410 series for 3.15.
Which might also be good to let all the other series touching samsung clock 
code settle.


Heiko

> 
> >>          select CPU_ARM926T
> >>          select CPU_LLSERIAL_S3C2440
> >>          select S3C2412_COMMON_CLK
> >> 
> >> @@ -51,6 +52,7 @@ config CPU_S3C2412
> >> 
> >>   config CPU_S3C2416
> >>   
> >>          bool "SAMSUNG S3C2416/S3C2450"
> >>          select COMMON_CLK
> >> 
> >> +       select COMMON_CLK_SAMSUNG
> >> 
> >>          select CPU_ARM926T
> >>          select CPU_LLSERIAL_S3C2440
> >>          select S3C2416_PM if PM
> >> 
> >> @@ -89,6 +91,7 @@ config CPU_S3C244X
> >> 
> >>   config CPU_S3C2443
> >>   
> >>          bool "SAMSUNG S3C2443"
> >>          select COMMON_CLK
> >> 
> >> +       select COMMON_CLK_SAMSUNG
> >> 
> >>          select CPU_ARM920T
> >>          select CPU_LLSERIAL_S3C2440
> >>          select S3C2443_COMMON_CLK
> >> 
> >> _______________________________________________
> >> linux-arm-kernel mailing list
> >> linux-arm-kernel@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

