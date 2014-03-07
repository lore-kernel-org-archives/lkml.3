Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaCGXFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:05:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27874 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaCGXE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:04:59 -0500
Date: Sat, 8 Mar 2014 02:04:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: josh@joshtriplett.org
Cc: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
        alistair@popple.id.au, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <error27@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: rfc: checkpatch logical line continuations (was IBM Akebono: Add
 support for a new PHY interface to the IBM emac driver)
Message-ID: <20140307230420.GH29018@mwanda>
References: <1394077948-8395-1-git-send-email-alistair@popple.id.au>
 <1394077948-8395-3-git-send-email-alistair@popple.id.au>
 <20140307.154142.488351276799532264.davem@davemloft.net>
 <1394226164.16156.96.camel@joe-AO722>
 <20140307213017.GA18769@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307213017.GA18769@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 01:30:17PM -0800, josh@joshtriplett.org wrote:
> On Fri, Mar 07, 2014 at 01:02:44PM -0800, Joe Perches wrote:
> > On Fri, 2014-03-07 at 15:41 -0500, David Miller wrote:
> > > From: Alistair Popple <alistair@popple.id.au>
> > > Date: Thu,  6 Mar 2014 14:52:25 +1100
> > > 
> > > > +	out_be32(dev->reg, in_be32(dev->reg) | WKUP_ETH_RGMIIEN
> > > > +		 | WKUP_ETH_TX_OE | WKUP_ETH_RX_IE);
> > > 
> > > When an expression spans multiple lines, the lines should end with
> > > operators rather than begin with them.
> > 
> > That's not in CodingStyle currently.
> 
> It's also not even remotely consistent across existing kernel code, and
> it isn't obvious that there's a general developer consensus on the
> "right" way to write it.
> 

We just had this discussion in staging and Greg modified the patch to
put the operator at the end.

https://lkml.org/lkml/2014/2/25/125

It's like logical && and || operators which go at the end these days.
I don't really want to have a lot of checkpatch churn to convert
everything...

regards,
dan carpenter

