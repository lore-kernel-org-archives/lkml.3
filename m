Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3EVSuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:50:12 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:13175 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752218Ab3EVSuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:50:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OnFmtQ9aYyG4Ymuh6MO6E3ha6i2LsNl8=
Date: Wed, 22 May 2013 14:49:36 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "tiejun.chen" <tiejun.chen@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH v4 06/12] ARM: dove: add gigabit ethernet and mvmdio
 device tree nodes
Message-ID: <20130522184936.GK31290@titan.lakedaemon.net>
References: <519C9333.20609@gmail.com>
 <519C9822.9040909@windriver.com>
 <519C9A66.3050807@gmail.com>
 <20130522131010.GB31290@titan.lakedaemon.net>
 <20130522165908.GB12320@obsidianresearch.com>
 <519D0143.1000203@gmail.com>
 <20130522173505.GH31290@titan.lakedaemon.net>
 <519D038C.9000605@gmail.com>
 <20130522174815.GI31290@titan.lakedaemon.net>
 <519D1204.4090701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519D1204.4090701@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 08:44:20PM +0200, Sebastian Hesselbarth wrote:
> On 05/22/2013 07:48 PM, Jason Cooper wrote:
> >On Wed, May 22, 2013 at 07:42:36PM +0200, Sebastian Hesselbarth wrote:
> >>Hmm, maybe a little bit too early. While restoring the MAC address now
> >>works, another bug arises which I guess is related with phy setup
> >>and aneg.
> >>
> >>Will investigate and update patch set accordingly.
> >
> >Cool, chances are, we should be able to take that patch in by itself for
> >this merge window...
> 
> Which patch do you mean? The local-mac-address workaround will only be
> available for DT mv643xx_eth because it uses the DT node to store the
> MAC.

I thought you were replacing the unconditional ethernet clock grabbing
with reading the mac from the registers and updating the dtb?  In
mach-kirkwood/board-dt.c?

confused. :-/

Jason.
