Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaCYUlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:41:53 -0400
Received: from fieldses.org ([174.143.236.118]:46027 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbaCYUlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:41:51 -0400
Date: Tue, 25 Mar 2014 16:41:50 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: "J. Bruce Fields" <bfields@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFSD, lost nfserrno() call in nfsd_setattr()
Message-ID: <20140325204149.GB30430@fieldses.org>
References: <20699.1392737273@jrobl>
 <20140218204438.GA12930@fieldses.org>
 <6158.1395735542@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6158.1395735542@jrobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 05:19:02PM +0900, J. R. Okajima wrote:
> 
> "J. Bruce Fields":
> > On Wed, Feb 19, 2014 at 12:27:53AM +0900, J. R. Okajima wrote:
> > > 
> > > There is a regression in
> > > 	208d0ac 2014-01-07 nfsd4: break only delegations when appropriate
> > > which deletes an nfserrno() call in nfsd_setattr() (by accident,
> > > probably), and NFSD becomes ignoring an error from VFS.
> > > 
> > > Here is a patch to fix it.
> >
> > Thanks for cathing that!  Queueing up for 3.14.
> 
> Now rc8 is released, but this patch is still un-merged.
> The bug is actually a show-stopper for my local tests.
> Do you really have a plan to do it? Or should I ask Linus Torvalds
> directly?

If you remember, just bug me once a week or so.  Snd then if it gets
this late, yes, sending straight to Linus with a cc: to the unresponsive
maintainer and any relevant mailing list is probably a reasonable thing
to do in this sort of situation.

Anyway, my screwup, apologies for not getting that merged at the start.

--b.
