Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3GBUVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:21:21 -0400
Received: from fenja.rhi.hi.is ([130.208.165.103]:49433 "EHLO fenja.rhi.hi.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab3GBUVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:21:19 -0400
X-Greylist: delayed 716 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2013 16:21:19 EDT
Date: Tue, 2 Jul 2013 19:49:47 +0000
From: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: 3.10.0-rc7: rtc_cmos.o: No linking because of missing
 CONFIG_HPET
Message-ID: <20130702194947.GA4240@rhi.hi.is>
References: <20130629204217.GA2589@rhi.hi.is>
 <51D14128.3040608@suse.cz>
 <51D14E78.7040309@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D14E78.7040309@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 11:40:08AM +0200, Clemens Ladisch wrote:
> > On 29.6.2013 22:42, Bjarni Ingi Gislason wrote:
> >>   The file "drivers/rtc/rtc_cmos.c" needs CONFIG_HPET to get linked.
> >>
> >> rtc-cmos.c:(.text+0x16f214): undefined reference to `hpet_rtc_interrupt'
> 
> CONFIG_HPET enables drivers/char/hpet.c and nothing else; it does not
> affect the HPET RTC emulation.
> 
> You are probably searching for CONFIG_HPET_EMULATE_RTC.
> 

  Sorry.  I selected (configured) "HPET_TIMER" to fix the compilation
and linking (which automatically includes HPET_EMULATE_RTC).

-- 
Bjarni I. Gislason
