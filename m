Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537Ab3CHRzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:55:54 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:29089 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756917Ab3CHRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:55:53 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+uuMT3U+Z1yKFu3P9f7zZj
Date: Fri, 8 Mar 2013 09:55:39 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
Message-ID: <20130308175539.GG26093@atomide.com>
References: <1362738596.5994.48.camel@x61.thuisdomein>
 <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
 <20130308163507.GC26093@atomide.com>
 <1362763232.5994.75.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362763232.5994.75.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [130308 09:24]:
> On Fri, 2013-03-08 at 08:35 -0800, Tony Lindgren wrote:
> > I think the righ fix is to just add
> > 
> > config MACH_NOKIA_RM680
> > 	bool
> 
> I guess you meant MACH_NOKIA_RM696.

Ooops yes.
 
> > to the mach-omap2/Kconfig like we have for n8x0 also.
> 
> Should I draft a patch?

Sure that would be nice.

Tony
