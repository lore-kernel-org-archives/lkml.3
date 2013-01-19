Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab3ASFzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 00:55:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47459 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3ASFzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 00:55:07 -0500
Date: Sat, 19 Jan 2013 05:55:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
Message-ID: <20130119055501.GA2802@ZenIV.linux.org.uk>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
 <20130111103442.b80ddbfb11ef322ed28ca3b3@canb.auug.org.au>
 <50EFD824.3010502@imgtec.com>
 <20130112000336.1f24c42237fab4fe0c305ff6@canb.auug.org.au>
 <50F0296E.2000704@imgtec.com>
 <20130112120957.36df3412c9d6cca089a0340a@canb.auug.org.au>
 <20130112095507.GA1738@balrog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130112095507.GA1738@balrog>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 09:55:07AM +0000, James Hogan wrote:
> Hi Stephen, Al,
> 
> On Sat, Jan 12, 2013 at 12:09:57PM +1100, Stephen Rothwell wrote:
> > On Fri, 11 Jan 2013 15:02:06 +0000 James Hogan <james.hogan@imgtec.com> wrote:
> > >
> > > Okay, I've rebased the metag tree from linux-next onto the master branch
> > > of Al's signal tree (to get Vineet's GENERIC_SIGALTSTACK fix and
> > > GENERIC_SIGALTSTACK's eventual removal).
> > 
> > OK, but I hope you mentioned not rebasing to Al.
> 
> I'm still rebasing the metag tree, and it's not quite ready for -next so
> I don't mind if Al's tree rebases at this stage tbh.
> 
> Al: I don't know if you normally rebase your tree, but if it's okay with
> you I'll let you know when I need it not to be rebased.

Umm...  
	1) #master is definitely bad for base; #for-linus is much safer (and
sufficient for your case)
	2) I'm a couple of fix folds away from opening #no-rebase (and yes,
it'll be a superset of #for-linus)

FWIW, I'd suggest a rebase on top of signal.git#for-linus.  Noting in
the stem is visibly relevant in your case, AFAICS...
