Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3IXKZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:25:10 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:55392 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3IXKZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:25:07 -0400
Date: Tue, 24 Sep 2013 12:25:05 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fan Du <fan.du@windriver.com>, Joe Perches <joe@perches.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the ipsec-next tree with the
 net-next tree
Message-ID: <20130924102505.GS7660@secunet.com>
References: <20130924121629.f818475ddf308b0494cfce2a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130924121629.f818475ddf308b0494cfce2a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 24 Sep 2013 10:25:06.0095 (UTC) FILETIME=[566D6BF0:01CEB910]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen.

On Tue, Sep 24, 2013 at 12:16:29PM +1000, Stephen Rothwell wrote:
> Hi Steffen,
> 
> Today's linux-next merge of the ipsec-next tree got a conflict in
> include/net/xfrm.h between commit d511337a1eda ("xfrm.h: Remove extern
> from function prototypes") from the net-next tree and commit aba826958830
> ("{ipv4,xfrm}: Introduce xfrm_tunnel_notifier for xfrm tunnel mode
> callback") from the ipsec-next tree.
> 

Thanks for the information, I'll do a rebase of the ipsec-next
tree tomorrow.

