Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956Ab3BUUnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:43:53 -0500
Received: from ozlabs.org ([203.10.76.45]:41195 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab3BUUnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:43:52 -0500
From: Michael Neuling <mikey@neuling.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: manual merge of the signal tree with the powerpc tree
In-reply-to: <1361425813.4676.47.camel@pasglop>
References: <20130221155208.bcb1295ab9bdecf394d48bfc@canb.auug.org.au> <1361425813.4676.47.camel@pasglop>
Comments: In-reply-to Benjamin Herrenschmidt <benh@kernel.crashing.org>
   message dated "Wed, 20 Feb 2013 23:50:13 -0600."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Thu, 21 Feb 2013 14:43:49 -0600
Message-ID: <27231.1361479429@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Thu, 2013-02-21 at 15:52 +1100, Stephen Rothwell wrote:
> > Hi Al,
> > 
> > Today's linux-next merge of the signal tree got conflicts in
> > arch/powerpc/kernel/signal_32.c and arch/powerpc/kernel/signal_64.c
> > between commit 2b0a576d15e0 ("powerpc: Add new transactional memory state
> > to the signal context") from the powerpc tree and commit 7cce246557bf
> > ("powerpc: switch to generic sigaltstack") from the signal tree.
> > 
> > I fixed it up (I think - see below) and can carry the fix as necessary
> > (no action is required).
> 
> Mikey, can you check everything's all right ?
> 
> I'm happy to wait for Al stuff to go in first & fixup the conflict
> before I send the pull request to Linus. I'm off travelling around but I
> should be able to get stuff out this week-end.

The merge looks fine to me.  My TM signal tests still pass on
next-20130221.

Thanks sfr!

Mikey
