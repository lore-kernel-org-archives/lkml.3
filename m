Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbaE2TRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:17:49 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55139 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753815AbaE2TRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:17:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/yxRTfzwZ4CA01XQ/zIOCi
Date: Thu, 29 May 2014 12:17:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: SX1: remove check for CONFIG_SX1_OLD_FLASH
Message-ID: <20140529191738.GA18567@atomide.com>
References: <1400182902.11786.21.camel@x220>
 <20140516211231.GF12881@atomide.com>
 <20140529190227.GB18230@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529190227.GB18230@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [140529 12:03]:
> On Fri 2014-05-16 14:12:31, Tony Lindgren wrote:
> > * Paul Bolle <pebolle@tiscali.nl> [140515 12:42]:
> > > A check for CONFIG_SX1_OLD_FLASH was added in v2.6.24. But the related
> > > Kconfig symbol was never part of the tree. So we can remove some dead
> > > code.
> > 
> > Thanks applying into omap-for-v3.16/board.
> 
> Actually... It seems there are two variant of SX1, and this is very
> useful piece of documentation how the _other_ variant looks.
> 
> And if someone is hacking linux on sx1, he can probably figure out
> #ifdef in .c file...
> 
> IOW adding the config option might be better solution.

Or just a comment saying the same?

Regards,

Tony
