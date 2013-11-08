Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab3KHPLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:11:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32479 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab3KHPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:11:28 -0500
Message-ID: <527CFEEF.6040708@oracle.com>
Date: Fri, 08 Nov 2013 09:10:39 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Kent Overstreet <kmo@daterainc.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the block tree with the  tree
References: <52740EB1.2070901@kernel.dk> <527411DD.7050008@oracle.com> <527414DE.9090704@kernel.dk> <52756583.2030808@oracle.com> <527BE7FA.90904@oracle.com> <20131107192545.GA20624@moria.home.lan> <527C2AA9.9040608@oracle.com> <20131108125307.613427c04a7527c4359e6443@canb.auug.org.au> <20131108020805.GI3842@kmo> <527C4D35.8000907@oracle.com> <20131108073324.GA31662@infradead.org>
In-Reply-To: <20131108073324.GA31662@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 01:33 AM, Christoph Hellwig wrote:
> Btw, I have to state that I very much disagree with dropping the
> direct I/O kernel changes, and I also very much disagree with keeping
> the immutable iovecs in.
> 
> For the latter I think the immutable iovecs are useful and do want to
> see them eventually, but they were merged at the latest possible point
> in the merge window and cause breakage all over the tree, so they very
> clearly are not ready at this point, and I fear even more breakage if
> they do get merged.
> 
> The changes for direct I/O from kernel space have been in for a long
> time, and they are blocking multiple consumers of the interface from
> getting submitted for about a year now.  Even if the guts of the
> direct-io code will get a write based on another patchset from Kent
> that will go on top of the immutable iovec changes we need the
> interfaces now and not another year down the road.

Sorry Christoph,
I guess I made a rash decision to pull this from linux-next. I
underestimated the dependencies others had on this.

Stephen,
How about you pick this up again for now? Unfortunately, I'm going to be
on a cruise next week and basically out of touch after today until a
week from Monday. That will give Kent some more time to ponder things
before I ask Linus to merge it.

Thanks,
Sorry for being a hassle.

Shaggy
