Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab3HMPLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:11:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12835 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757573Ab3HMPLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:11:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+IpvdQAhVjeKA0EbJeBW6z1pHlMClgsOM=
Date: Tue, 13 Aug 2013 11:11:23 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/5] ARM: dove: DT PCIe support
Message-ID: <20130813151123.GB25111@titan.lakedaemon.net>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130813140130.GA25111@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813140130.GA25111@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:01:30AM -0400, Jason Cooper wrote:
> Bjorn,
> 
> On Tue, Aug 13, 2013 at 02:25:19PM +0200, Sebastian Hesselbarth wrote:
> > This patch set adds support for the PCIe controllers found on Marvell
> > Dove SoCs. It depends on mvebu-pci patches sent by Thomas Petazzoni.
> 
> Well, when it rains, it pours.  If this series looks good to you, I'll
> go ahead and add it on top of Thomas' patches.

And I can confirm, this series definitely depends on mvebu/boards,
mvebu/mbus_dt, and mvebu/msi_mvebu (which, in turn, depends on
mvebu/msi_irq and mvebu/msi_pci).

thx,

Jason.
