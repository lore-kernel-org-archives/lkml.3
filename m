Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaH2Pt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:49:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:47709 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaH2Pty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:49:54 -0400
Message-ID: <5400A11A.7000202@linutronix.de>
Date: Fri, 29 Aug 2014 17:49:46 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 05/15] tty: serial: Add 8250-core based omap driver
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de> <1408124563-31541-6-git-send-email-bigeasy@linutronix.de> <20140815210716.GE9239@atomide.com> <20140815224446.GF9239@atomide.com>
In-Reply-To: <20140815224446.GF9239@atomide.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2014 12:44 AM, Tony Lindgren wrote:

> Oh and echo mem > /sys/power/state and then hitting a key on the serial
> console won't wake the system. Does that need to be manually configured
> for device_may_wakeup()?

This is what it looks like:

/# echo enabled >
/sys/devices/68000000.ocp/49020000.serial/tty/ttyS2/power/wakeup

/ # date; echo mem > /sys/power/state; date
Sat Jan  1 07:01:41 UTC 2000
[  249.916503] PM: Syncing filesystems ... done.
[  252.674652] Freezing user space processes ... (elapsed 0.001 seconds)
done.
[  252.683563] Freezing remaining freezable tasks ... (elapsed 0.001
seconds) done.
[  252.693084] Suspending console(s) (use no_console_suspend to debug)
[  252.715820] PM: suspend of devices complete after 11.688 msecs
[  252.722015] PM: late suspend of devices complete after 6.195 msecs
[  252.729187] PM: noirq suspend of devices complete after 7.110 msecs
[  252.729278] Successfully put all powerdomains to target state
[  252.733306] PM: noirq resume of devices complete after 3.967 msecs
[  252.738708] PM: early resume of devices complete after 4.425 msecs
[  252.910400] PM: resume of devices complete after 171.569 msecs
[  252.957855] Restarting tasks ... done.
Sat Jan  1 07:01:51 UTC 2000


>  

Sebastian
