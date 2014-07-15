Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaGOQNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:13:05 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59384 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaGOQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:12:58 -0400
Date: Tue, 15 Jul 2014 09:12:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/7] kernel: Add support for restart notifier call
 chain
Message-ID: <20140715161251.GA14534@roeck-us.net>
References: <1405265431-4561-1-git-send-email-linux@roeck-us.net>
 <1405265431-4561-2-git-send-email-linux@roeck-us.net>
 <20140714145311.GC1112@arm.com>
 <53C3F033.9070408@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C3F033.9070408@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 07:58:59AM -0700, Guenter Roeck wrote:
> On 07/14/2014 07:53 AM, Catalin Marinas wrote:
[ ... ]
> >
> >I'm not fully convinced implying a 'notifier' is the right approach
> >here. By analogy with the reboot notifier, this is something drivers
> >would want to know about and do some work before the actual system
> >restart (e.g. disable watchdogs as in the reboot notifier case). The
> >restart notifier here is meant to perform the actual system restart.
> >Arguably, the actual restart should be handled by priority 0 with some
> >preparation before but we have reboot notifier already, so I don't think
> >it's worth another notifier.
> >
> >While re-using the notifier mechanism behind the scene is fine, I think
> >we should at least rename the functions to something like
> >(un)register_restart_handler().
> >
> 
> Fine with me. Any other comments / suggestions on the name of the function ?
> 
Any further feedback on the function names ? If not I'll resubmit the series
tonight or tomorrow morning with the functions renamed as suggested above.

Guenter
