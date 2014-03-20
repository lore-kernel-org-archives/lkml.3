Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbaCTQTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:19:36 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:59709 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbaCTQTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:19:35 -0400
Date: Thu, 20 Mar 2014 10:19:24 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2a 1/2] dt: Document a compatible entry for MDIO
 ethernet Phys
Message-ID: <20140320161924.GA8855@obsidianresearch.com>
References: <1395267324-5788-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <532AA634.5090707@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532AA634.5090707@codethink.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 09:26:28AM +0100, Ben Dooks wrote:

> >+  If the phy's identifier is known then the list may contain an entry
> >+  of the form: "ethernet-phy-idAAAA.BBBB" where
> >+     AAAA - The value of the 16 bit Phy Identifier 1 register as
> >+            4 hex digits. This is the chip vendor OUI bits 3:18
> >+     BBBB - The value of the 16 bit Phy Identifier 2 register as
> >+            4 hex digits. This is the chip vendor OUI bits 19:24,
> >+            followed by 10 bits of a vendor specific ID.
> >+
> 
> How about having "ethernet-phy" and adding a single property in the
> PHY node saying phy-id = <AAAABBBB>, which would be much easier to
> parse.

That option was discussed (and my first patch was this way)..

However, using the compatible string is consistent with other OF
schemes, such as PCI which uses compatible strings like pciVVVV,DDDD
pciclass,CCSS and so on.

It does make a fair amount sense because the purpose of compatible is
to identify the device.

Jason
