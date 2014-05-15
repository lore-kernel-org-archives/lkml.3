Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaEONfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:35:03 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26679 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaEONfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:35:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18uXhqftp9EBTRTRLbiT/q040quqHiZGNc=
X-DKIM: OpenDKIM Filter v2.0.1 titan A00E55762D1
Date: Thu, 15 May 2014 09:34:44 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
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
Subject: Re: [PATCH v6 17/17] ARM: mvebu: add Device Tree description of
 the EHCI controller on Armada 375
Message-ID: <20140515133444.GN27822@titan.lakedaemon.net>
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
 <1400149062-32661-18-git-send-email-gregory.clement@free-electrons.com>
 <5374C08C.7040700@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5374C08C.7040700@cogentembedded.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 05:26:36PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 05/15/2014 02:17 PM, Gregory CLEMENT wrote:
> 
> >The Marvell Armada 375 SoCs contains one EHCI controller. This commit
> 
>    However, you're adding two. :-)

So it would seem.  Gregory, I'll fix it up when I pull it in.  No need
to respin.

thx,

Jason.
