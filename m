Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaH2QIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:08:50 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39171 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbaH2QIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:08:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19DOhE+TFEsh31sfQXDIMcf
Date: Fri, 29 Aug 2014 09:08:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 05/15] tty: serial: Add 8250-core based omap driver
Message-ID: <20140829160842.GN16006@atomide.com>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <1408124563-31541-6-git-send-email-bigeasy@linutronix.de>
 <20140815210716.GE9239@atomide.com>
 <20140815224446.GF9239@atomide.com>
 <5400A11A.7000202@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5400A11A.7000202@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140829 08:50]:
> On 08/16/2014 12:44 AM, Tony Lindgren wrote:
> 
> > Oh and echo mem > /sys/power/state and then hitting a key on the serial
> > console won't wake the system. Does that need to be manually configured
> > for device_may_wakeup()?
> 
> This is what it looks like:
> 
> /# echo enabled >
> /sys/devices/68000000.ocp/49020000.serial/tty/ttyS2/power/wakeup
> 
> / # date; echo mem > /sys/power/state; date
> Sat Jan  1 07:01:41 UTC 2000
> [  249.916503] PM: Syncing filesystems ... done.
> [  252.674652] Freezing user space processes ... (elapsed 0.001 seconds)
> done.
> [  252.683563] Freezing remaining freezable tasks ... (elapsed 0.001
> seconds) done.
> [  252.693084] Suspending console(s) (use no_console_suspend to debug)
> [  252.715820] PM: suspend of devices complete after 11.688 msecs
> [  252.722015] PM: late suspend of devices complete after 6.195 msecs
> [  252.729187] PM: noirq suspend of devices complete after 7.110 msecs
> [  252.729278] Successfully put all powerdomains to target state
> [  252.733306] PM: noirq resume of devices complete after 3.967 msecs
> [  252.738708] PM: early resume of devices complete after 4.425 msecs
> [  252.910400] PM: resume of devices complete after 171.569 msecs
> [  252.957855] Restarting tasks ... done.
> Sat Jan  1 07:01:51 UTC 2000

Yes works for me too now thanks.

Tony
