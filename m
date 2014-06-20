Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934359AbaFTVK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:10:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:45017 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaFTVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:10:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX199e10GRWFo4rI3pPxVvy1xdyHoTW82Qik=
X-DKIM: OpenDKIM Filter v2.0.1 titan 5C8E4594A0E
Date: Fri, 20 Jun 2014 17:10:12 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mvebu: rename ARM_ERRATA_753970
Message-ID: <20140620211012.GP21711@titan.lakedaemon.net>
References: <201404052101.19381.arnd@arndb.de>
 <201404052104.11363.arnd@arndb.de>
 <1396777049.30640.9.camel@x220>
 <53418889.2050002@free-electrons.com>
 <1396805315.7723.8.camel@x220>
 <1401094871.25902.20.camel@x220>
 <20140620202100.GG21711@titan.lakedaemon.net>
 <1403296977.16903.10.camel@x41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403296977.16903.10.camel@x41>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:42:57PM +0200, Paul Bolle wrote:
> Jason Cooper schreef op vr 20-06-2014 om 16:21 [-0400]:
> > It looks like rmk just added a patch to fixing the selection of the
> > erratas.  Could you please take a look and either rebase or drop this
> > patch?
> 
> Sure, no problem. What tree should I check?

It's

  a641f3a6abce ARM: l2c: fix dependencies on PL310 errata symbols

in Russell's fixes branch:

  http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-arm.git fixes

thx,

Jason.
