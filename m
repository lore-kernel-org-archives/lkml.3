Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaLIXOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 18:14:08 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43574 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754222AbaLIXOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 18:14:06 -0500
X-Sasl-enc: fEp4QeKWBk385PZYFggRAalNuDc+3QXpE+M+bW3Gozyf 1418166845
Date: Tue, 9 Dec 2014 18:14:05 -0500
From: Christoph Jaeger <cj@linux.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, yann.morin.1998@free.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 2/3] kconfig: remove undocumented type definition alias
 'boolean'
Message-ID: <20141209231405.GC9677@betelgeuse.hsd1.ma.comcast.net>
References: <cover.1418003065.git.cj@linux.com>
 <1539c3778a0f3533942f69540a9b5b3d1f965bdc.1418003065.git.cj@linux.com>
 <1418064660.2058.11.camel@x220>
 <1418066039.2058.19.camel@x220>
 <5485F923.3090301@redhat.com>
 <1418067685.2058.27.camel@x220>
 <1418070979.2058.52.camel@x220>
 <1418073300.2058.63.camel@x220>
 <5486E1BD.4040809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5486E1BD.4040809@redhat.com>
X-Homepage: http://christophjaeger.info
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 12:49:17PM +0100, Daniel Borkmann wrote:
> On 12/08/2014 10:15 PM, Paul Bolle wrote:
> >On Mon, 2014-12-08 at 21:36 +0100, Paul Bolle wrote:
> >>On Mon, 2014-12-08 at 20:41 +0100, Paul Bolle wrote:
> >>>Well, it seems the treewide "boolean" cleanup should be done first.
> >>>Removing support for "boolean" could than be a second, separate step.
> >>>Just to ease review.
> >>
> >>This appears to have no effect on the .config files I generated for the
> >>defconfig files in next-20141208. (After porting the patch and changing
> >>those last booleans to bool, that is.) So that's good.
> >>
> >>If you'd resend as two patches on top of linux-next, I might add an
> >>Acked-by: or a Tested-by:.
> >
> >My last mail on this series. To make sure the tree stays buildable that
> >second patch to drop support for 'boolean' should only be applied a
> >release or two after the cleanup patch has been applied. Otherwise we're
> >bound to run into fun build errors in linux-next, and even mainline, for
> >quite a few commits, aren't we? One tree still using boolean is all it
> >takes...
> 
> Sounds like a good plan, thanks a lot for looking into it, Paul!
> 
> Meanwhile, also checkpatch.pl could emit a deprecate warning in case
> a patch carries Kconfig code with 'boolean' in it, but I leave that
> up to Christoph to decide. ;)

Agree. Thanks for reviewing and testing!

I'll resend a series on top of linux-next that takes all of your suggestions
into account.

Thanks,
Chris
