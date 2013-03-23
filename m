Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3CXJSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 05:18:10 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62234 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3CXJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 05:17:50 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 23 Mar 2013 12:02:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ben Collins <benmcollins13@gmail.com>
Cc: David Miller <davem@davemloft.net>, afleming@freescale.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Add support for handling queueing in hardware
Message-ID: <20130323190221.GA22005@roeck-us.net>
References: <E1UJ1fR-0004hs-4l@swissweb.swissdisk.com>
 <20130322.101139.1942128058226201237.davem@davemloft.net>
 <A5ACC15C-361D-48E6-BFFF-9AA3966C2A68@freescale.com>
 <20130322.103302.1277256650283142022.davem@davemloft.net>
 <FE78128C-01DB-4831-ACBE-BA3E3A428BFC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FE78128C-01DB-4831-ACBE-BA3E3A428BFC@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 10:43:44AM -0400, Ben Collins wrote:
> On Mar 22, 2013, at 10:33 AM, David Miller <davem@davemloft.net> wrote:
> 
> > From: Fleming Andy-AFLEMING <afleming@freescale.com>
> > Date: Fri, 22 Mar 2013 14:31:50 +0000
> > 
> >> It would appear one of our customers is attempting to upstream our
> >> code for us. We are aware that this current solution is unacceptable
> >> (which is why we have not submitted it), and we are currently trying
> >> to develop a less hacky solution that integrates with qdisc.
> > 
> > Ben, can can you coordinate with people instead of doing crap like
> > this?
> 
> 
> "For us" is a loose term, when it's more that we are attempting to upstream code so our system is supported by a mainline kernel instead of having one-off kernels.
> 
> And we have been talking with Freescale about this for quite some time (couple years?). They have a roadmap that doesn't include getting this driver supported in mainline any time soon, so I'm taking time to get this done for our own system. I'm not meaning to step on any toes.
> 
How true. You are not the only one with thatt problem.

Ben, can you possibly send me your complete patch set on top of 3.8, or point me
to a git tree ?

I have exactly the same problem, I need the code in 3.8, it doesn't seem
like the Freescale code will show up anytime soon, and I don't seem to be able
to get early code for testing either. I can promise you a free test coverage
and bug fixing ...

Thanks,
Guenter
