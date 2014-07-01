Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbaGAMus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:50:48 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64442 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaGAMuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:50:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195o8NYdKxqBeI4KeKAktcT
Date: Tue, 1 Jul 2014 05:50:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Benoit Cousson <bcousson@baylibre.com>, robh+dt@kernel.org,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        Rajendra Nayak <rnayak@ti.com>, Nishanth Menon <nm@ti.com>,
        r.sricharan@ti.com, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/2] arm: dts: add support for am437x sk
Message-ID: <20140701125041.GP28884@atomide.com>
References: <1403547659-24558-1-git-send-email-balbi@ti.com>
 <20140630164543.GA31442@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630164543.GA31442@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140630 09:47]:
> Hi,
> 
> On Mon, Jun 23, 2014 at 01:20:57PM -0500, Felipe Balbi wrote:
> > Hi,
> > 
> > here's v3 of am437x sk support. Patches tested on top of next-20140617.
> > 
> > Note that this series was tested with the following extra patches:
> > 
> > http://marc.info/?l=linux-omap&m=140299431732700&w=2
> > http://marc.info/?l=linux-omap&m=140300146503126&w=2
> > http://marc.info/?l=linux-omap&m=140299231232123
> > http://marc.info/?l=linux-omap&m=140310472709968&w=2
> > http://marc.info/?l=linux-omap&m=140310471409959&w=2
> > 
> > A branch is also available with all these patches at [1].
> > 
> > [1] http://git.kernel.org/cgit/linux/kernel/git/balbi/usb.git/log/?h=am437x-starterkit
> > 
> > Felipe Balbi (2):
> >   arm: dts: am4372: let boards access all nodes through phandles
> >   arm: dts: add support for AM437x StarterKit
> 
> ping on this series, it has been tested by several folks and still no
> updates from anybody in the DT land.

Thanks applying both into omap-for-v3.17/dt branch.

Regards,

Tony
