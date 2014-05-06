Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059AbaEFDOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:14:15 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42905 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbaEFDON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:14:13 -0400
Date: Tue, 6 May 2014 05:14:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 09/24] net, diet: Make ethtool optional
Message-ID: <20140506031412.GN2382@two.firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <1399328773-6531-10-git-send-email-andi@firstfloor.org>
 <20140505.231140.2172378266544060318.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505.231140.2172378266544060318.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 11:11:40PM -0400, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Mon,  5 May 2014 15:25:58 -0700
> 
> > Small embedded systems don't need ethtool, so make it optional.
> 
> You can't do anything non-trivial with an ethernet device without
> ethtool.

You can configure the IP address and transmit and receive packets,
and that is all a small embedded system is ever interested in.

Remember these systems don't have a shell, they just run a 
single application that only does one thing.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
