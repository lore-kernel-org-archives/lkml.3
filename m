Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3CBNpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:45:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:27250 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab3CBNpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:45:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,767,1355126400"; 
   d="scan'208";a="293918919"
Date: Sat, 2 Mar 2013 21:45:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Felipe Balbi <balbi@ti.com>, Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [usb gadget] WARNING: at kernel/mutex.c:198 __mutex_lock_common()
Message-ID: <20130302134536.GA16893@localhost>
References: <20130206020424.GB1175@localhost>
 <20130227104935.GZ8016@arwen.pp.htv.fi>
 <20130302133736.GA13058@localhost>
 <51320173.6000802@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51320173.6000802@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 02:41:07PM +0100, Sebastian Andrzej Siewior wrote:
> On 03/02/2013 02:37 PM, Fengguang Wu wrote:
> > On Wed, Feb 27, 2013 at 12:49:35PM +0200, Felipe Balbi wrote:
> >> Hi,
> >>
> >> On Wed, Feb 06, 2013 at 10:04:24AM +0800, Fengguang Wu wrote:
> >>> Greetings,
> >>>
> >>> I got the below warning and the first bad commit is
> >>
> >> can you send a fixup patch ?
> > 
> > Sorry I don't have the fix. Maarten once proposed
> > 
> > : Can you change __mutex_lock_common from inline to __always_inline and
> > : check if that gets rid of the warning?
> > 
> > and it worked at that time, however it does not work today when I
> > go out to double check the below patch...
> 
> This does not get even close to a fix, not to mention a proper one. The
> problem is that a spinlock is hold while a mutex is going to be taken.
> Maybe I get to this?

That'd be great. I can help test your patch out.

Thanks,
Fengguang
