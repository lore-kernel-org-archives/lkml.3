Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992AbaEFDLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:11:31 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42874 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbaEFDL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:11:28 -0400
Date: Tue, 6 May 2014 05:11:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 12/24] net, diet: Make rtnetlink optional
Message-ID: <20140506031127.GM2382@two.firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <1399328773-6531-13-git-send-email-andi@firstfloor.org>
 <20140505.230830.1291070654883866275.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505.230830.1291070654883866275.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The moment one of these "small" systems, or whatever you want to call
> it, tries to use any feature added to device configuration in the last
> 20 years ioctl doesn't cut it.

They will simply not use all that complexity ever, 400k is simply prohibitive
with 2MB.

If you want to keep netlink what would you remove instead?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
