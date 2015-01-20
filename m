Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbbATQs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:48:27 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32522 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755494AbbATQsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:48:23 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Ej0UK+pBAeHp49X7aBhkJ
Date: Tue, 20 Jan 2015 08:44:55 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: ARM: OMAP3: MACH_OMAP3517EVM?
Message-ID: <20150120164455.GD7718@atomide.com>
References: <1421744597.9655.92.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421744597.9655.92.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [150120 01:06]:
> Tony,
> 
> Your commit 4d62dbda8561 ("ARM: OMAP3: Remove legacy support for
> am3517-evm") is included in today's linux-next (ie, next-20150120). I
> noticed because a script I use to check linux-next spotted a problem
> caused by it.

OK thanks for spotting that.
 
> See, your commit removes the Kconfig symbol MACH_OMAP3517EVM. But
> there's still a reference to that symbol in sound/soc/omap/Kconfig. This
> means that in linux-next a symbol, SND_OMAP_SOC_AM3517EVM, cannot be set
> anymore.
> 
> I assume a patch that address this (either by removing
> SND_OMAP_SOC_AM3517EVM or by updating its dependencies) is queued
> somewhere. Is that correct?

Not yet, I missed that part sorry. I'll add back the Kconfig symbol.
I'll rather do the removal in smaller steps, and first remove the
3517 related board-*.c file before messing with the legacy drivers.

Regards,

Tony
