Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab3CUGB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:01:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab3CUGBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:01:54 -0400
Date: Thu, 21 Mar 2013 08:02:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, jasowang@redhat.com, basil.gor@gmail.com,
        nab@risingtidesystems.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] vhost/net: fix heads usage of ubuf_info
Message-ID: <20130321060218.GB23908@redhat.com>
References: <20130317124609.GA25967@redhat.com>
 <20130317.142955.1114572401286297685.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317.142955.1114572401286297685.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 02:29:55PM -0400, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Sun, 17 Mar 2013 14:46:09 +0200
> 
> > ubuf info allocator uses guest controlled head as an index,
> > so a malicious guest could put the same head entry in the ring twice,
> > and we will get two callbacks on the same value.
> > To fix use upend_idx which is guaranteed to be unique.
> > 
> > Reported-by: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Applied and queued up for -stable, thanks.
> 
> And thankfully you got the stable URL wrong,

Yes I wrote stable@kernel.org that's what an old copy
says here:
https://www.kernel.org/doc/Documentation/stable_kernel_rules.txt

I should have known better than look at it on the 'net.  The top
'Everything you ever wanted to know about Linux 2.6 -stable releases.'
is a big hint that it's stale.
Any idea who maintains this? Better update it or remove it or redirect to git.

> please do not CC:
> networking patches to stable, just make sure I apply them and in
> your post-commit text explicitly ask me to queue it up to my
> -stable queue.
> 
> Thanks.
