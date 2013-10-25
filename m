Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3JYObN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:31:13 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33470 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3JYObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:31:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+X/mc3tXRGlxjjLA3G0SF/
Date: Fri, 25 Oct 2013 07:31:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: NeilBrown <neilb@suse.de>, Russell King <linux@arm.linux.org.uk>,
        Belisko Marek <marek.belisko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "Fernandes, Joel" <joelf@ti.com>
Subject: Re: [PATCH 0/2] ARM: OMAP: dmtimers improvements.
Message-ID: <20131025143103.GZ15154@atomide.com>
References: <20131024065536.16889.49902.stgit@notabene.brown>
 <448912EABC71F84BBCADFD3C67C4BE5291DD30@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <448912EABC71F84BBCADFD3C67C4BE5291DD30@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shilimkar, Santosh <santosh.shilimkar@ti.com> [131024 11:11]:
> Sorry for top posting .... Probably we should move the dmtimer to drivers/misc or create drivers/timer/
> This has been pending for quite some time now....
> 
> Tony, what you say ?

Yes that should be done and we should cc Thomas Gleixner to
see if he has any better ideas for some of those exported
functions. Things that can be done with hrtimer should be done
with hrtimer, but at least the coprocessor use of timers and
PWM need to use timers directly.

Regards,

Tony
