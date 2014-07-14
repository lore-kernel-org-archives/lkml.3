Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaGNHHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:07:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39868 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaGNHHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:07:17 -0400
Date: Mon, 14 Jul 2014 08:07:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [patch 35/55] mfd: cros_ec_spi: Use ktime_get_ns()
Message-ID: <20140714070710.GH2954@lee--X1>
References: <20140711133623.530368377@linutronix.de>
 <20140711133708.263040802@linutronix.de>
 <20140711145212.GG2954@lee--X1>
 <alpine.DEB.2.10.1407122134470.4357@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.10.1407122134470.4357@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2014, Thomas Gleixner wrote:
> On Fri, 11 Jul 2014, Lee Jones wrote:
> 
> > > Replace the ever recurring:
> > > 	ts = ktime_get_ts();
> > > 	ns = timespec_to_ns(&ts);
> > > with
> > > 	ns = ktime_get_ns();
> > > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > 
> > Only Sam?  How old is your version of MAINTAINERS?
> 
> Hmm. I use get_maintainers.pl and manually edit it afterwards. Seems
> that I killed one extra line :)
>  
> > Sam hasn't actively maintained MFD for over a year now.
> > 
> > Patch applied though, thanks.
> 
> ktime_get_ns() is not upstream yet, it's part of the series I posted :)
> 
> If you ack it, i'll carry it and also remove the now unused variable
> ts before applying it.

Very well.  Patch looks good to me:

  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
