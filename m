Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbaGARJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:09:08 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51699 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758705AbaGARJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:09:04 -0400
Date: Tue, 1 Jul 2014 18:08:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 0/6] kernel: Add support for restart notifier call
 chain
Message-ID: <20140701170853.GX18313@arm.com>
References: <1404155499-21177-1-git-send-email-linux@roeck-us.net>
 <20140630195946.GI32514@n2100.arm.linux.org.uk>
 <20140630202851.GA12888@roeck-us.net>
 <20140701112413.GQ18313@arm.com>
 <53B2BB74.7050300@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B2BB74.7050300@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 02:45:24PM +0100, Guenter Roeck wrote:
> On 07/01/2014 04:24 AM, Catalin Marinas wrote:
> > On Mon, Jun 30, 2014 at 09:28:51PM +0100, Guenter Roeck wrote:
> >> What is restart-poweroff supposed to do in the first place, and why
> >> doesn't it call machine_restart() ? If it is what I think it is, ie
> >> a fallback for pm_power_off, it could be made generic and does not
> >> really have to depend on ARM.
> >
> > I think this one pretends to do a power-off via restart. It could call
> > machine_restart() but this only passes the default reboot_mode to
> > arm_pm_restart().
> 
> Unless one sets reboot_mode first. See my proposed patch in
> https://lkml.org/lkml/2014/6/30/792.

It looks fine to me.

-- 
Catalin
