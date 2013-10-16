Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594Ab3JPJUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:20:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760182Ab3JPJUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:20:08 -0400
Date: Wed, 16 Oct 2013 11:20:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Maxime Jayat <maxime@artisandeveloppeur.fr>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the trivial tree
In-Reply-To: <alpine.DEB.2.10.1310161057190.13374@blackhole.kfki.hu>
Message-ID: <alpine.LNX.2.00.1310161118070.12405@pobox.suse.cz>
References: <1381845763-10487-1-git-send-email-treding@nvidia.com> <1381845763-10487-2-git-send-email-treding@nvidia.com> <alpine.DEB.2.10.1310161057190.13374@blackhole.kfki.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Jozsef Kadlecsik wrote:

> > Today's linux-next merge of the trivial tree got conflicts in
> > 
> > 	net/netfilter/xt_set.c
> > 
> > caused by commits 3f79410 (treewide: Fix common typo in "identify") and
> > bd3129f (netfilter: ipset: order matches and targets separatedly in
> > xt_set.c).
> > 
> > I fixed them up (see below). Please verify that the resolution looks
> > good.
> 
> I don't really get it: patch bd3129f was part of a patchset, which was 
> applied to net-next and there it was complete.
> 
> There's none of the patchset in question in linux-next, so what's the 
> trivial tree? Where's lost what?
> 
> [The patch below doesn't look good, because it should contain the removed 
> part for the revision 1 match due to the reordering in the file.]

This is just a super-simple conflict between

	https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=bd3129f

and

	https://git.kernel.org/cgit/linux/kernel/git/jikos/trivial.git/diff/net/netfilter/xt_set.c?h=for-next&id=3f79410c7c

I don't think it needs any special handling, do you? I can of course drop 
the respective hunk from my tree and let you handle it in net-next if you 
wish.

Thanks,

-- 
Jiri Kosina
SUSE Labs
