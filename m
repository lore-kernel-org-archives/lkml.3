Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaJCUoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:44:09 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:48317 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJCUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:44:07 -0400
Date: Fri, 3 Oct 2014 15:43:59 -0500
From: Michael Welling <mwelling@ieee.org>
To: David Miller <davem@davemloft.net>
Cc: tony@atomide.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:ethernet:davinci_emac.c:Fixes flaw in mac
 address handling.
Message-ID: <20141003204359.GA10110@sysresccd>
References: <1412217125-11057-1-git-send-email-mwelling@ieee.org>
 <20141003.130305.2216770567363258603.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003.130305.2216770567363258603.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 01:03:05PM -0700, David Miller wrote:
> From: Michael Welling <mwelling@ieee.org>
> Date: Wed,  1 Oct 2014 21:32:05 -0500
> 
> > The code currently checks the mac_addr variable that is clearly
> > zero'd out during allocation.
> > 
> > Further code is added to bring the mac_addr from the partial pdata.
> > 
> > Signed-off-by: Michael Welling <mwelling@ieee.org>
> 
> I don't see anyone specifying a MAC address in the partial pdata,
> so better to just delete that field.
> 
> Even if people did, I am not so sure that the partial pdata should
> unconditionally trump an OF provided MAC address.

So should I just leave the code for handling the mac_addr field from the
partial pdata out or make it such that the mac_addr field is overriden 
if specified from the devicetree?

