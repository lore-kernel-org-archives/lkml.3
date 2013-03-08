Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551Ab3CHSKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:10:42 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:31191 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759575Ab3CHSKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:10:41 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ZTup5sT5gd7mAOjAbNJtB
Date: Fri, 8 Mar 2013 10:10:29 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
Message-ID: <20130308181029.GF11806@atomide.com>
References: <1362738596.5994.48.camel@x61.thuisdomein>
 <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
 <20130308163507.GC26093@atomide.com>
 <1362763232.5994.75.camel@x61.thuisdomein>
 <20130308175539.GG26093@atomide.com>
 <1362765764.5994.87.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362765764.5994.87.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [130308 10:06]:
> On Fri, 2013-03-08 at 09:55 -0800, Tony Lindgren wrote:
> > * Paul Bolle <pebolle@tiscali.nl> [130308 09:24]:
> > > Should I draft a patch?
> > 
> > Sure that would be nice.
> 
> One thing I couldn't determine is how the generated mach-types.h header
> handles multiple CONFIG_MACH_* macros.
> 
> If both CONFIG_MACH_FOO and CONFIG_MACH_BAR are defined, and these both
> have a line in */mach-types, will the machine_is_foo() and
> machine_is_bar() macros both behave as one would expect?

Yes they do, for the selected ones the macro becomes
machine_arch_type == MACH_TYPE_XYZ instead of 0.

Regards,

Tony
