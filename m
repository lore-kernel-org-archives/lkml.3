Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3IYF32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 01:29:28 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:48999 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3IYF30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 01:29:26 -0400
Date: Wed, 25 Sep 2013 07:29:23 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fan Du <fan.du@windriver.com>, Joe Perches <joe@perches.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the ipsec-next tree with the
 net-next tree
Message-ID: <20130925052923.GU7660@secunet.com>
References: <20130924121629.f818475ddf308b0494cfce2a@canb.auug.org.au>
 <20130924102505.GS7660@secunet.com>
 <20130925095919.143635403832766c1b190202@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925095919.143635403832766c1b190202@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 25 Sep 2013 05:29:24.0381 (UTC) FILETIME=[31F474D0:01CEB9B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 09:59:19AM +1000, Stephen Rothwell wrote:
> Hi Steffen,
> 
> On Tue, 24 Sep 2013 12:25:05 +0200 Steffen Klassert <steffen.klassert@secunet.com> wrote:
> >
> > On Tue, Sep 24, 2013 at 12:16:29PM +1000, Stephen Rothwell wrote:
> > > 
> > > Today's linux-next merge of the ipsec-next tree got a conflict in
> > > include/net/xfrm.h between commit d511337a1eda ("xfrm.h: Remove extern
> > > from function prototypes") from the net-next tree and commit aba826958830
> > > ("{ipv4,xfrm}: Introduce xfrm_tunnel_notifier for xfrm tunnel mode
> > > callback") from the ipsec-next tree.
> > 
> > Thanks for the information, I'll do a rebase of the ipsec-next
> > tree tomorrow.
> 
> Did you miss the end of the next paragraph:  "no action is required"?
> Dave can fix this up (like I did) when he merges your tree into his.
> 

I applied this patch shortly before the merge window opened, it is a left
over from the last develpoment cycle. I already rebased my tree onto
net-next in the past if that happened, even if there were no merge
conflicts. I did that just to see if everything still works. But I
could also do a test merge to see if everything still works and ask
to pull without a rebase then if this is the prefered way. Would make
my life easier :)

