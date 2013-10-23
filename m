Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3JWCL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:11:58 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41969 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3JWCL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:11:57 -0400
Date: Wed, 23 Oct 2013 04:11:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: David Miller <davem@davemloft.net>, andi@firstfloor.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: wan: sbni: remove assembly crc32 code
Message-ID: <20131023021156.GG29695@two.firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
 <1382458346-24811-12-git-send-email-andi@firstfloor.org>
 <20131022.135928.2040131908206663695.davem@davemloft.net>
 <20131022183625.GA4382@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022183625.GA4382@breakpoint.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 08:36:25PM +0200, Sebastian Andrzej Siewior wrote:
> 
> There is also a C function doing the same thing. Unless the asm code is
> 110% faster we could stick to the C function.

I have no idea if it is or not. But doing it this way would be
acceptable for me.

Thanks for the patch.

-Andi
