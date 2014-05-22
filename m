Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaEVOI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:08:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12129 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750899AbaEVOI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:08:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ULUKle8gdapp9L1t4Dak4qafCaaIlCoE=
X-DKIM: OpenDKIM Filter v2.0.1 titan CB92557D2D3
Date: Thu, 22 May 2014 10:08:38 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 10/17] ARM: mvebu: add USB3 support for Armada 38x
Message-ID: <20140522140838.GM8664@titan.lakedaemon.net>
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
 <1400149062-32661-11-git-send-email-gregory.clement@free-electrons.com>
 <20140516190729.GN27822@titan.lakedaemon.net>
 <1400497768.2007.10.camel@x220>
 <537CAFD2.3080807@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537CAFD2.3080807@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 03:53:22PM +0200, Gregory CLEMENT wrote:
> On 19/05/2014 13:09, Paul Bolle wrote:
> > On Fri, 2014-05-16 at 15:07 -0400, Jason Cooper wrote:
> >> On Thu, May 15, 2014 at 12:17:35PM +0200, Gregory CLEMENT wrote:
> >>> This patch adds the selection of the config symbol needed to build the
> >>> USB3 support for Armada 38x into mvebu_v7_defconfig.
> >>>
> >>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> >>> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> >>> ---
> >>>  arch/arm/mach-mvebu/Kconfig | 1 +
> >>>  1 file changed, 1 insertion(+)
> >>
> >> Patches 10 and 11 applied to mvebu/soc
> > 
> > These two just hit linux-next (in next-20140519). They're pointless, as
> > config USB_ARCH_HAS_XHCI was dropped in commit b797b76fb464 ("usb: host:
> > remove USB_ARCH_HAS_?HCI").
> 
> Right! We didn't notice it.
> 
> Jason you can simply remove them from mvebu/soc when you will submit the pull request

Now dropped from mvebu/soc.

thx,

Jason.
