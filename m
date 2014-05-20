Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaETQF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:05:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:43891 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaETQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:05:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+BN1x/L5U9dxqvlIOrkFwJ
Date: Tue, 20 May 2014 09:05:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Bolle <pebolle@tiscali.nl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: remove ARM710 specific assembler code
Message-ID: <20140520160512.GE27830@atomide.com>
References: <1364507176.1345.45.camel@x61.thuisdomein>
 <20140517094636.GP3693@n2100.arm.linux.org.uk>
 <9DBC3527-1961-40DD-8CBA-9A1B5D3003C9@arm.com>
 <5053472.zFAHKQVpbv@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5053472.zFAHKQVpbv@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [140519 04:27]:
> On Saturday 17 May 2014 10:56:02 Catalin Marinas wrote:
> 
> For the case of ARM710T, I think the last remaining user that can be
> configured is mach-integrator, but I don't know if anybody even has that
> CPU tile, or wants to keep using it. If Russell and Linus as the only
> people that have cared about Integrator in the past years want to
> cut down the number of supported CPUs, that would be a different matter:
> quite a number of CPUs are not supported in any other platform.
> Note that the integrator target in qemu does not support any ARM7, only
> StrongARM, ARM9 or later. I also double-checked about mach-clps711x,
> but I'm pretty sure those SoCs are all either ARM710a (no longer supported)
> or ARM720T (quite active).

Hmm I don't think mach-integrator is using ARM710T?

The ARM710T was done by NEC and was used by the Psion MX hardware.
It's very close to ARM720T as far as I remember so might as well keep
the CPU support for it as that's just a few lines of code in the
mainline kernel.

I don't think we have any mach directories using ARM710T, but I
would not be surprised if somebody comes along with device tree
based booting patches for Psion MX at some point.

Regards,

Tony
