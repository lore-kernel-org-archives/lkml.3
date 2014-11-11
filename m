Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaKKGHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:07:39 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54046 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbaKKGHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:07:37 -0500
X-Sasl-enc: x1Z0W3xfn1Yz51yRMl6hZiMs5GjM2D9jxNut6Vmjx477 1415686055
Message-ID: <1415686048.2486.20.camel@perseus.themaw.net>
Subject: Re: [PATCH 1/3] autofs - fix log print messages
From: Ian Kent <raven@themaw.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 11 Nov 2014 14:07:28 +0800
In-Reply-To: <1415684989.16070.2.camel@perches.com>
References: <20141111012954.25773.4002.stgit@perseus.themaw.net>
	 <1415676341.16070.0.camel@perches.com>
	 <1415684245.2486.9.camel@perseus.themaw.net>
	 <1415684989.16070.2.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 21:49 -0800, Joe Perches wrote:
> On Tue, 2014-11-11 at 13:37 +0800, Ian Kent wrote:
> > On Mon, 2014-11-10 at 19:25 -0800, Joe Perches wrote:
> > > On Tue, 2014-11-11 at 09:29 +0800, Ian Kent wrote:
> > > > Fix some inconsistencies in log print output and ensure that
> > > > the module name is included in all log prints.
> > > > 
> > > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > > Cc: Joe Perches <joe@perches.com>
> > > > ---
> > > >  fs/autofs/autofs_i.h  |    6 +++---
> > > >  fs/autofs/dev-ioctl.c |    2 +-
> > > >  fs/autofs/inode.c     |   10 +++++-----
> > > >  fs/autofs/waitq.c     |    4 ++--
> > > >  4 files changed, 11 insertions(+), 11 deletions(-)
> > > 
> > > What tree are these patches made against?
> > 
> > They live in an StGit patch queue against the current Linus tree.
> > They depend on the prior series to rename autofs4 to autofs.
> 
> Hey Ian.
> 
> Maybe you could add the git tree location to
> the MAINTAINERS entry:
> 
> MAINTAINERS-KERNEL AUTOMOUNTER v4 (AUTOFS4)
> MAINTAINERS-M:  Ian Kent <raven@themaw.net>
> MAINTAINERS-L:  autofs@vger.kernel.org
> MAINTAINERS-S:  Maintained
> MAINTAINERS:F:  fs/autofs4/

... and I forgot about updating that fs/autofs4/ in MAINTAINERS too, ha,
that'll need another patch.

Ian

