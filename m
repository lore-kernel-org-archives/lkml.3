Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaKFQwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:52:18 -0500
Received: from sub4.mail.dreamhost.com ([69.163.253.135]:50390 "EHLO
	homiemail-a108.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbaKFQwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:52:14 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2014 11:52:14 EST
From: "Gerald Coley" <gerald@granddesignsgroup.com>
To: "'Tony Lindgren'" <tony@atomide.com>, "'Nishanth Menon'" <nm@ti.com>
Cc: "'Tom Rini'" <trini@ti.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <beagleboard@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <fcooper@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <1415290702-11353-1-git-send-email-nm@ti.com> <20141106163207.GF16896@saruman> <545BA3E6.90105@ti.com> <545BA513.2090907@ti.com> <20141106164843.GY31454@atomide.com>
In-Reply-To: <20141106164843.GY31454@atomide.com>
Subject: RE: [PATCH] ARM: dts: Add am57xx-beagle-x15
Date: Thu, 6 Nov 2014 10:51:04 -0600
Message-ID: <006701cff9e1$dc0cfbf0$9426f3d0$@granddesignsgroup.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJ5YymWdDQwubU8pfQPSxvpkvgedgHJv6/0AndAuUsCKD3UZAGQewkVmsEvXzA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert 12V to 5V and 3.3V. 5V supplies are too expensive at the required
wattage level.

Gerald


-----Original Message-----
From: Tony Lindgren [mailto:tony@atomide.com] 
Sent: Thursday, November 6, 2014 10:49 AM
To: Nishanth Menon
Cc: Tom Rini; balbi@ti.com; devicetree@vger.kernel.org;
beagleboard@googlegroups.com; linux-kernel@vger.kernel.org;
gerald@granddesignsgroup.com; fcooper@ti.com; linux-omap@vger.kernel.org;
linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: Add am57xx-beagle-x15

* Nishanth Menon <nm@ti.com> [141106 08:44]:
> On 11/06/2014 10:37 AM, Tom Rini wrote:
> 
> >>> device_type = "memory"; +		reg = <0x80000000 0x40000000>; /*
1GB
> >>> to start. Target 2GB */
> >>
> >> 1GiB ? Why would you put this here btw ? u-boot fills this one up.
> > 
> > Yes, it should either be the full and correct value or 0x0 (like a 
> > number of PowerPC platforms do) so it's clear something else gives 
> > us the right value here.
> 
> Honest mistake, my bad.. I thought I cleaned up the patch! Sigh!!! i 
> will repost with proper 2GB. it is better that way in case being used 
> with "other bootloaders" which are not exactly too good like u-boot.

Can you also describe why all the always-on regulators are needed?

Regards,

Tony

