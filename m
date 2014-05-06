Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851AbaEFDDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:03:32 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42808 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaEFDDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:03:31 -0400
Date: Tue, 6 May 2014 05:03:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 13/24] net, diet: Make GRO offload optional
Message-ID: <20140506030328.GK2382@two.firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <1399328773-6531-14-git-send-email-andi@firstfloor.org>
 <20140505.230118.938429615465621236.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505.230118.938429615465621236.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 11:01:18PM -0400, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Mon,  5 May 2014 15:26:02 -0700
> 
> > It's not needed on small systems.
> 
> On the contrary, I would expect the performance gains from
> batching the packet receive path to be even larger on slow
> small computers.

Ok I will rephrase it. The issue is really only the text size.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
