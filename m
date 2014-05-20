Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaETHGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:06:53 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:52385 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaETHGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:06:50 -0400
Date: Tue, 20 May 2014 08:06:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andreas Werner <andreas.werner@men.de>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        cooloney@gmail.com, rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        johannes.thumshirn@men.de, thomas.schnuerer@men.de, wernerandy@gmx.de
Subject: Re: [PATCH 1/3] drivers/mfd/menf21bmc: introduce MEN 14F021P00 BMC
 MFD Core driver
Message-ID: <20140520070644.GB20874@lee--X1>
References: <cover.1400258021.git.andreas.werner@men.de>
 <58de41a38511a107941d9c3b2cea314c0becfff7.1400258021.git.andreas.werner@men.de>
 <5377849E.7020001@roeck-us.net>
 <20140519124324.GB398@awelinux>
 <537A05D4.6080308@roeck-us.net>
 <20140519173953.GA20874@lee--X1>
 <20140520074748.GC398@awelinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140520074748.GC398@awelinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Not my call to make; depends on the mfd maintainer. I would not accept it, as I see it
> > > as unnecessary, adding complexity, and pointless. Sure, you can always find examples
> > > for everything somewhere in the kernel, but that doesn't make it better.
> > 
> > I'm inclined to agree with Guenter, this patch is just noise.
> 
> Ok no problem, i will fix it and resend the patch.
> For now I know it for the future :-)
> 
> Any other comments about the patch series?

If you submit a v2, I'll re-review the bits you leave in.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
