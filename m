Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaCSVrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:47:42 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:35030 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbaCSVrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:47:41 -0400
Date: Wed, 19 Mar 2014 21:47:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/8] mfd: lpc_ich: Fix ACPI enable bitmask
Message-ID: <20140319214736.GC20260@lee--X1>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <20140313151601.GA4479@roeck-us.net>
 <20140313152534.GC10356@lee--X1>
 <20140313225040.GK28504@lee--X1>
 <53223964.2080408@roeck-us.net>
 <20140314102934.GA3432@lee--X1>
 <20140319171748.GA3842@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140319171748.GA3842@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > >>>>The original bitmask of 0x10 was incorrect and would result in a write
> > > >>>>to a reserved read-only bit instead of enabling the ACPI I/O
> > > >>>>region.  Update it to the proper value of 0x80.
> > > >>>>
> > > >>>>Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> > > >>>>Tested-by: Rajat Jain <rajatjain@juniper.net>
> > > >>>>Cc: Guenter Roeck <linux@roeck-us.net>
> > > >>>>Cc: James Ralston <james.d.ralston@intel.com>
> > > >>>>Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > >>>>Cc: Lee Jones <lee.jones@linaro.org>
> > > >>>
> > > >>>Who is going to pick up this series ?
> > > >>
> > > >>I will, once I've completed the review.
> > > >
> > > >Okay review complete, phew!
> > > >
> > > >Guenter, How do you want to play this? Do you want me to create an
> > > >immutable branch for you to pull from?
> > > >
> > > 
> > > I'll be happy if I can pull it from -next. Is it going to be there
> > > anytime soon ?
> > 
> > Well I pushed an updated version of the MFD today, so it should appear
> > in -next this evening.
> > 
> Hi Lee,
> 
> for some reason I still don't see the patches in linux-next, even though I see
> them in your mfd-next branch. Any idea what is happening ? Is it possible
> that Stephen picks up a different mfd-next tree ?

Yes, that's exactly what was happening.

I emailed Stephen a few hours ago to rectify the situation.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
