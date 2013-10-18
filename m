Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3JRQ4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:56:49 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58225 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3JRQ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:56:47 -0400
Date: Fri, 18 Oct 2013 09:49:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Kevin Hilman <khilman@linaro.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUILD BROKEN] Current Linus' master and -next don't build for
 imx_v6_v7_defconfig
Message-ID: <20131018164915.GA29015@roeck-us.net>
References: <Pine.LNX.4.64.1310181632160.9158@axis700.grange>
 <CAGa+x86+qfWBou2jkEjz10ix95m89cxnyyFOPwryF27YezeoPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGa+x86+qfWBou2jkEjz10ix95m89cxnyyFOPwryF27YezeoPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 08:14:36AM -0700, Kevin Hilman wrote:
> On Fri, Oct 18, 2013 at 7:59 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> 
> > On current Linus' tree as of 04919af as well as -next since 16.10, IIRC,
> > compilation is broken for i.MX3*, including the default
> > imx_v6_v7_defconfig. The toolchain used is
> >
> > arm-none-linux-gnueabi-gcc (Sourcery CodeBench Lite 2012.09-64) 4.7.2
> 
> Just for another data point, I'm not seeing this in my builds
> (arm-linux-gnueabi-gcc (Ubuntu/Linaro 4.7.2-1ubuntu1) 4.7.2) and we're
> not seeing this in Olof's autobuilds either for latest mainline[1] or
> latest next-thierry[2].  I belive Olof is using vanilla gcc 4.8.1.
> 
> Kevin
> 
I don't see the problem either, using "arm-poky-linux-gnueabi-gcc (GCC) 4.7.2"
from Yocto 1.4.2.

Guenter
