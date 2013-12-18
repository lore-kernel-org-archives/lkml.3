Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3LRLdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:33:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43874 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3LRLdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:33:43 -0500
Date: Wed, 18 Dec 2013 12:33:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org,
        ffusco@redhat.com, dborkman@redhat.com, tgraf@redhat.com,
        Joe Perches <joe@perches.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20131218113324.GA30183@twins.programming.kicks-ass.net>
References: <20131218125643.8ff140371e1f8c306327d354@canb.auug.org.au>
 <20131217.212145.893665929052097867.davem@davemloft.net>
 <20131217.213033.1019416869378407851.davem@davemloft.net>
 <CAMuHMdUi4GQYR2p7enikEkTq1s-5YwirTzmo_tS0JwiE=dVmYw@mail.gmail.com>
 <20131218101523.GP13532@twins.programming.kicks-ass.net>
 <CAMuHMdXHiKe6fjEHu0GrSVMAmvKuX9wOUdC2MW3uSjRAU5tnWA@mail.gmail.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B74A4@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B74A4@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:07:34AM -0000, David Laight wrote:
> > > And sort(1) is annoying in that it doesn't do in-place sort; you'll end
> > > up with empty files if you try the naive thing.
> > >
> > > Worse most of those Kbuild files include other random garbage, which
> > > makes automated sorting harder still.
> > >
> > > So unless there's a sane and easy way to keep it sorted; I'm going to
> > > ignore that rule.
> > 
> > Not keeping them sorted causes merge conflicts and duplicate/missing
> > entries.

Surely sorting doesn't cure missing entries. Also sorting can at most
reduce merge conflicts, not take them out entirely.

> Edit in vi put cursor on the first line to be sorted and type !}sort
> (assuming there is a nice blank line at the end).

That's a manual operation, and therefore disqualified.
