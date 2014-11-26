Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaKZFRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:17:21 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48083 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752329AbaKZFRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:17:16 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+XtXV6Wd/IJrFAfJ6iBxtRvfNfxLV4n8=
X-DKIM: OpenDKIM Filter v2.0.1 titan CB54A6240D9
Date: Wed, 26 Nov 2014 00:17:01 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] ARM: mvebu: add PHY support to the dts for the
 USB controllers on Armada 375
Message-ID: <20141126051701.GU22670@titan.lakedaemon.net>
References: <1415879269-29711-1-git-send-email-gregory.clement@free-electrons.com>
 <1415879269-29711-7-git-send-email-gregory.clement@free-electrons.com>
 <20141122020811.GO22670@titan.lakedaemon.net>
 <5470556B.6080608@free-electrons.com>
 <20141126035929.GJ22670@titan.lakedaemon.net>
 <54756164.3070206@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54756164.3070206@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 10:43:08AM +0530, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Wednesday 26 November 2014 09:29 AM, Jason Cooper wrote:
> > On Sat, Nov 22, 2014 at 10:20:43AM +0100, Gregory CLEMENT wrote:
> >> Hi Jason,
> >>
> >> On 22/11/2014 03:08, Jason Cooper wrote:
> >>> On Thu, Nov 13, 2014 at 12:47:48PM +0100, Gregory CLEMENT wrote:
> >>>> Now that the USB cluster node has been added, use it as a PHY provider
> >>>> for the USB controller linked to it: the first EHCI and the xHCI.
> >>>>
> >>>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> 
> Looks like I'm not cc'ed in v4 of this patch series :-(

I've bounced emails maybe three times in my life.  Thought it might work
here.  Did it?

thx,

Jason.
