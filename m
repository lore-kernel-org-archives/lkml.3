Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3CXJSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 05:18:05 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62238 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab3CXJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 05:17:50 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 23 Mar 2013 12:10:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Theodore Ts'o" <tytso@mit.edu>, Ben Collins <benmcollins13@gmail.com>,
        David Miller <davem@davemloft.net>, afleming@freescale.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Add support for handling queueing in hardware
Message-ID: <20130323191023.GB22005@roeck-us.net>
References: <A5ACC15C-361D-48E6-BFFF-9AA3966C2A68@freescale.com>
 <20130322.103302.1277256650283142022.davem@davemloft.net>
 <FE78128C-01DB-4831-ACBE-BA3E3A428BFC@gmail.com>
 <20130322.111759.2108472348146991505.davem@davemloft.net>
 <20130322220840.GA6647@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322220840.GA6647@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 06:08:40PM -0400, Theodore Ts'o wrote:
> On Fri, Mar 22, 2013 at 11:39:20AM -0400, Ben Collins wrote:
> > 
> > If your company had hardware going to production, you'd want it supported in mainline too, I suspect.
> 
> And if companies told their hardware partners that they will drop use
> of their hardware in future products unless they get their !@#@S
> drivers upstream, I'd bet they'd change their engineering priorities
> so they would work on it, instead of foisting this work on their
> customers.
> 
I would love to be in that position. However, the decision to choose
a specific chip is not always coordinated with those who have to provide
the software to run on those chips.

> I've seen this work in enterprise computing, where the RFP had
> requirements for upstream drivers (i.e., if you want your 10gig
> ethernet NIC to be used in HP or IBM's servers, get the darned thing
> upstream!).  The trick is making it clear that selection of components
> depends not just on an OSS driver, but an OSS driver which has been
> accepted upstream (which also helps from a quality-of-code
> requirement).
> 
> I've been waiting for this to start happening in the consumer
> electronics/embedded world, but it's been slow coming,
> unfortunately....
> 
The same applies to vendors of non-consumer network devices, unfortunately.

Guenter
