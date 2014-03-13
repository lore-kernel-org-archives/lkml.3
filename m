Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaCMPZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:25:42 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:36559 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaCMPZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:25:41 -0400
Date: Thu, 13 Mar 2014 15:25:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/8] mfd: lpc_ich: Fix ACPI enable bitmask
Message-ID: <20140313152534.GC10356@lee--X1>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <20140313151601.GA4479@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140313151601.GA4479@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The original bitmask of 0x10 was incorrect and would result in a write
> > to a reserved read-only bit instead of enabling the ACPI I/O
> > region.  Update it to the proper value of 0x80.
> > 
> > Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> > Tested-by: Rajat Jain <rajatjain@juniper.net>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > Cc: James Ralston <james.d.ralston@intel.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> 
> Who is going to pick up this series ?

I will, once I've completed the review.

> It should also be noted that Avoton/Rangeley support for the iTCO watchdog
> has been broken since Avoton support was introduced in 3.11 and causes either
> a system hangup or reboot if enabled with those CPUs. We should either
> back-port this series (or at least the patches related to watchdog support)
> to the affected kernels, or revert commit 8477128 (Add support for Intel
> Avoton SoC).

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
