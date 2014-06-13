Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaFMQhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:37:31 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64915 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaFMQh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:37:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX189B4seZhmYM5arIL5UW0vgV5h4uPEPOZ0=
X-DKIM: OpenDKIM Filter v2.0.1 titan D248F58EFB8
Date: Fri, 13 Jun 2014 12:37:14 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Joe Perches <joe@perches.com>
Cc: Sricharan R <r.sricharan@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 00/19] irqchip: crossbar: driver fixes
Message-ID: <20140613163714.GR8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <20140613150122.GP8664@titan.lakedaemon.net>
 <1402676074.12385.40.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402676074.12385.40.camel@joe-AO725>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 09:14:34AM -0700, Joe Perches wrote:
> On Fri, 2014-06-13 at 11:01 -0400, Jason Cooper wrote:
> > Please format the subject lines like so:
> > 
> >   irqchip: crossbar: Set cb pointer ...
> >                      ^
> >                      |
> >                      \-- note the capitalization
> 
> I suggest you don't make this a rule and focus
> on more important stuff instead.

It's not my rule.  ;-)

> Nobody is going to write tools that parse the
> changelogs by "git log --format=%s" for case
> sensitivity.
> 
> As is, it's about half/half.
> 
> $ git log --format=%s --no-merges drivers/irqchip/ | \
>   grep "^irqchip:" | cut -f3- -d":"

Yeah, we haven't been perfect in the past, and a lot of stuff was merged
without going though tglx's tree.  That's why I was asked to help out.

Either I'm fixing up the subject line as I apply the patch, or, I kindly
ask the submitter to fix it up during a re-spin.

thx,

Jason.
