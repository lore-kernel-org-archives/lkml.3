Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517Ab3JPUKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:10:38 -0400
Received: from smtp-in.kfki.hu ([148.6.0.26]:47188 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760948Ab3JPUKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:10:37 -0400
Date: Wed, 16 Oct 2013 22:10:34 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Jiri Kosina <jkosina@suse.cz>, Thierry Reding <thierry.reding@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        Maxime Jayat <maxime@artisandeveloppeur.fr>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the trivial tree
In-Reply-To: <20131016145652.GB16959@localhost>
Message-ID: <alpine.DEB.2.10.1310162200180.17770@blackhole.kfki.hu>
References: <1381845763-10487-1-git-send-email-treding@nvidia.com> <1381845763-10487-2-git-send-email-treding@nvidia.com> <alpine.DEB.2.10.1310161057190.13374@blackhole.kfki.hu> <alpine.LNX.2.00.1310161118070.12405@pobox.suse.cz>
 <20131016145652.GB16959@localhost>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Pablo Neira Ayuso wrote:

> On Wed, Oct 16, 2013 at 11:20:04AM +0200, Jiri Kosina wrote:
> > On Wed, 16 Oct 2013, Jozsef Kadlecsik wrote:
> > 
> > > > Today's linux-next merge of the trivial tree got conflicts in
> > > > 
> > > > 	net/netfilter/xt_set.c
> > > > 
> > > > caused by commits 3f79410 (treewide: Fix common typo in "identify") and
> > > > bd3129f (netfilter: ipset: order matches and targets separatedly in
> > > > xt_set.c).
> > > > 
> > > > I fixed them up (see below). Please verify that the resolution looks
> > > > good.
> > > 
> > > I don't really get it: patch bd3129f was part of a patchset, which was 
> > > applied to net-next and there it was complete.
> > > 
> > > There's none of the patchset in question in linux-next, so what's the 
> > > trivial tree? Where's lost what?
> 
> To Jozsef: David collects all the networking patches in net-next until
> Linus' merge window opens, that's why you don't see your patches in
> linux-next. It seems Jiri merges this trivial tree (which indeed
> contains your net-next patches already) to linux-next.
> 
> > > [The patch below doesn't look good, because it should contain the removed 
> > > part for the revision 1 match due to the reordering in the file.]
> > 
> > This is just a super-simple conflict between
> > 
> > 	https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=bd3129f
> > 
> > and
> > 
> > 	https://git.kernel.org/cgit/linux/kernel/git/jikos/trivial.git/diff/net/netfilter/xt_set.c?h=for-next&id=3f79410c7c
> > 
> > I don't think it needs any special handling, do you? I can of course drop 
> > the respective hunk from my tree and let you handle it in net-next if you 
> > wish.
> 
> Please, don't drop it, I think Jozsef got confused by the handling of
> your trivial tree.
 
I was confused mainly because Thierry sent just the relevant part and I 
expected a full patch :-). So it's just fine.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
