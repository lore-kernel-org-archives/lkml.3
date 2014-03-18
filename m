Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbaCRUg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:36:26 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:40094 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaCRUgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:36:25 -0400
Date: Tue, 18 Mar 2014 20:36:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 5/8] watchdog: iTCO_wdt: Add support for v3 silicon
Message-ID: <20140318203618.GY25478@lee--X1>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <1394487298-14459-5-git-send-email-ptyser@xes-inc.com>
 <20140315200309.GC14815@spo001.leaseweb.com>
 <20140318082759.GC25478@lee--X1>
 <20140318135918.GF1484@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140318135918.GF1484@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Some new Atom's, eg Avoton and Bay Trail, have slightly different iTCO
> > > > functionality:
> > > > - The watchdog timer ticks at 1 second instead of .6 seconds
> > > > 
> > > > - Some 8 and 16-bit registers were combined into 32-bit registers
> > > > 
> > > > - Some registers were removed (DAT_IN, DAT_OUT, MESSAGE)
> > > > 
> > > > - The BOOT_STS field in TCO_STS was removed
> > > > 
> > > > - The NO_REBOOT bit is in the PMC area instead of GCS
> > > > 
> > > > Update the driver to support the above changes and bump the version to
> > > > 1.11.
> > > > 
> > > > Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> > > > Tested-by: Rajat Jain <rajatjain@juniper.net>
> > > > Cc: Guenter Roeck <linux@roeck-us.net>
> > > > Cc: James Ralston <james.d.ralston@intel.com>
> > > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > > Cc: Lee Jones <lee.jones@linaro.org>
> > > > Cc: Wim Van Sebroeck <wim@iguana.be>
> > > > Cc: linux-watchdog@vger.kernel.org
> > > 
> > > Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> > 
> > Why Signed-off-by?
> 
> 1) I'm the author of iTCO_wdt.
> 2) I'm tha maintainer of the watchdog device drivers.

But you're not the author of this patch, or in the code path.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
