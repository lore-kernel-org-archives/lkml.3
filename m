Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab3AVToo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 14:44:44 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:37288 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3AVTon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 14:44:43 -0500
Date: Tue, 22 Jan 2013 12:44:33 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] timekeeping: Add CONFIG_HAS_PERSISTENT_CLOCK
 option
Message-ID: <20130122194433.GG30647@obsidianresearch.com>
References: <1358266189-8812-1-git-send-email-feng.tang@intel.com>
 <1358266189-8812-3-git-send-email-feng.tang@intel.com>
 <50F5B2FA.6030006@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F5B2FA.6030006@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:50:18AM -0800, John Stultz wrote:
> On 01/15/2013 08:09 AM, Feng Tang wrote:
> >Make the persistent clock check a kernel config option, so that some
> >platform can explicitely select it, also make CONFIG_RTC_HCTOSYS depends
> >on its non-existence, which could prevent the persistent clock and RTC
> >code from doing similar thing twice during system's init/suspend/resume
> >phases.
> >
> >If the CONFIG_HAS_PERSISTENT_CLOCK=n, then no change happens for kernel
> >which still does the persistent clock check in timekeeping_init().
> >
> >Cc: Thomas Gleixner <tglx@linutronix.de>
> >Suggested-by: John Stultz <john.stultz@linaro.org>
> >Signed-off-by: Feng Tang <feng.tang@intel.com>
> 
> Applied. I also added a dependency for Jason's CONFIG_RTC_SYSTOHC.

Sort of an ugly config name, since I gather ARM should always set this
to 'n'...

CONFIG_USE_ONLY_PERSISTENT_CLOCK ?

Cheers,
Jason
