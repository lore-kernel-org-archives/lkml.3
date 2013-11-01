Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab3KAH4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:56:21 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:49212 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab3KAH4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:56:17 -0400
Date: Fri, 1 Nov 2013 08:56:15 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: mroos@linux.ee
Cc: David Miller <davem@davemloft.net>, hannes@stressinduktion.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: 3.12-rc7 regression - network panic from ipv6
Message-ID: <20131101075615.GK31491@secunet.com>
References: <alpine.SOC.1.00.1310292221550.19416@math.ut.ee>
 <20131029210758.GA18323@order.stressinduktion.org>
 <alpine.SOC.1.00.1310292338010.22172@math.ut.ee>
 <20131029.174258.1677867676998240250.davem@davemloft.net>
 <20131030130945.GJ31491@secunet.com>
 <alpine.SOC.1.00.1310302340170.24516@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1310302340170.24516@math.ut.ee>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 01 Nov 2013 07:56:15.0776 (UTC) FILETIME=[D73D6200:01CED6D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 11:41:09PM +0200, mroos@linux.ee wrote:
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> Works fine, thanks!
> 
> Tested-by: Meelis Roos <mroos@linux.ee>
> 

I've applied the fix now to the ipsec tree. Again thanks for
reporting and testing!
