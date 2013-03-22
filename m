Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423369Ab3CVWIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:08:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55216 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422658Ab3CVWIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:08:47 -0400
Date: Fri, 22 Mar 2013 18:08:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ben Collins <benmcollins13@gmail.com>
Cc: David Miller <davem@davemloft.net>, afleming@freescale.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Add support for handling queueing in hardware
Message-ID: <20130322220840.GA6647@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ben Collins <benmcollins13@gmail.com>,
	David Miller <davem@davemloft.net>, afleming@freescale.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <A5ACC15C-361D-48E6-BFFF-9AA3966C2A68@freescale.com>
 <20130322.103302.1277256650283142022.davem@davemloft.net>
 <FE78128C-01DB-4831-ACBE-BA3E3A428BFC@gmail.com>
 <20130322.111759.2108472348146991505.davem@davemloft.net>
 <9AEAD974-4549-475A-AE15-C92523CD2466@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9AEAD974-4549-475A-AE15-C92523CD2466@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 11:39:20AM -0400, Ben Collins wrote:
> 
> If your company had hardware going to production, you'd want it supported in mainline too, I suspect.

And if companies told their hardware partners that they will drop use
of their hardware in future products unless they get their !@#@S
drivers upstream, I'd bet they'd change their engineering priorities
so they would work on it, instead of foisting this work on their
customers.

I've seen this work in enterprise computing, where the RFP had
requirements for upstream drivers (i.e., if you want your 10gig
ethernet NIC to be used in HP or IBM's servers, get the darned thing
upstream!).  The trick is making it clear that selection of components
depends not just on an OSS driver, but an OSS driver which has been
accepted upstream (which also helps from a quality-of-code
requirement).

I've been waiting for this to start happening in the consumer
electronics/embedded world, but it's been slow coming,
unfortunately....

                                                   - Ted
