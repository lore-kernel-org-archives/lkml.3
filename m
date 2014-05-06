Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881AbaEFDVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:21:17 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42925 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739AbaEFDVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:21:15 -0400
Date: Tue, 6 May 2014 05:21:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506032114.GP2382@two.firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <1399328773-6531-9-git-send-email-andi@firstfloor.org>
 <20140505.231229.136734008603421707.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505.231229.136734008603421707.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 11:12:29PM -0400, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Mon,  5 May 2014 15:25:57 -0700
> 
> > This is all the code that saves connection information
> > between different sockets. Not really essential for
> > small systems.
> 
> It is absolutely essential unless you want poor performance
> of TCP connections.

Ok so every code in the network stack is essential?

What parts would you remove to get the foot print down for a 2MB
single purpose machine?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
