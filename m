Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaCYITI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:19:08 -0400
Received: from mail04-md.ns.itscom.net ([175.177.155.114]:60287 "EHLO
	mail04-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaCYITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:19:05 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH] NFSD, lost nfserrno() call in nfsd_setattr()
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "J. Bruce Fields" <bfields@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140218204438.GA12930@fieldses.org>
References: <20699.1392737273@jrobl> <20140218204438.GA12930@fieldses.org>
Date: Tue, 25 Mar 2014 17:19:02 +0900
Message-ID: <6158.1395735542@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"J. Bruce Fields":
> On Wed, Feb 19, 2014 at 12:27:53AM +0900, J. R. Okajima wrote:
> > 
> > There is a regression in
> > 	208d0ac 2014-01-07 nfsd4: break only delegations when appropriate
> > which deletes an nfserrno() call in nfsd_setattr() (by accident,
> > probably), and NFSD becomes ignoring an error from VFS.
> > 
> > Here is a patch to fix it.
>
> Thanks for cathing that!  Queueing up for 3.14.

Now rc8 is released, but this patch is still un-merged.
The bug is actually a show-stopper for my local tests.
Do you really have a plan to do it? Or should I ask Linus Torvalds
directly?


J. R. Okajima
