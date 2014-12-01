Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaLAEzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 23:55:00 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47166 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaLAEy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 23:54:59 -0500
Date: Mon, 1 Dec 2014 10:24:46 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Hisashi T Fujinaka <htodd@twofifty.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Matthew Vick <matthew.vick@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000: remove unused variables
Message-ID: <20141201045446.GA3277@sudip-PC>
References: <1417065728-5592-1-git-send-email-sudipm.mukherjee@gmail.com>
 <alpine.NEB.2.11.1411262157110.1481@chris.i8u.org>
 <1417311913.7215.111.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417311913.7215.111.camel@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 01:45:13AM +0000, Ben Hutchings wrote:
> On Wed, 2014-11-26 at 21:59 -0800, Hisashi T Fujinaka wrote:
> > I'm pretty sure those double reads are there for a reason, so most of
> > this I'm going to have to check on Monday. We have a long holiday
> > weekend here in the US.
> [...]
> 
> If there were double register reads being replaced with single register
> reads, I'd agree this was likely to introduce a regression.  But all I
> see is var = er32(REG) being changed to er32(REG).

no, double register reads are not modified. only the unused variables are removed.

thanks
sudip

> 
> Ben.
> 
> -- 
> Ben Hutchings
> The world is coming to an end.	Please log off.


