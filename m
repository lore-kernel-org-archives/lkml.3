Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaKFQtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:49:45 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61445 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751809AbaKFQtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:49:42 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18byRvDMBUcfH39d0UdrtHf
Date: Thu, 6 Nov 2014 08:48:44 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Tom Rini <trini@ti.com>, balbi@ti.com, devicetree@vger.kernel.org,
        beagleboard@googlegroups.com, linux-kernel@vger.kernel.org,
        gerald@granddesignsgroup.com, fcooper@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: Add am57xx-beagle-x15
Message-ID: <20141106164843.GY31454@atomide.com>
References: <1415290702-11353-1-git-send-email-nm@ti.com>
 <20141106163207.GF16896@saruman>
 <545BA3E6.90105@ti.com>
 <545BA513.2090907@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545BA513.2090907@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [141106 08:44]:
> On 11/06/2014 10:37 AM, Tom Rini wrote:
> 
> >>> device_type = "memory"; +		reg = <0x80000000 0x40000000>; /* 1GB
> >>> to start. Target 2GB */
> >>
> >> 1GiB ? Why would you put this here btw ? u-boot fills this one up.
> > 
> > Yes, it should either be the full and correct value or 0x0 (like a
> > number of PowerPC platforms do) so it's clear something else gives us
> > the right value here.
> 
> Honest mistake, my bad.. I thought I cleaned up the patch! Sigh!!! i
> will repost with proper 2GB. it is better that way in case being used
> with "other bootloaders" which are not exactly too good like u-boot.

Can you also describe why all the always-on regulators are needed?

Regards,

Tony
