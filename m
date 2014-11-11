Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaKKFhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:37:32 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38878 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbaKKFhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:37:31 -0500
X-Sasl-enc: O6UXgA7/NMDyKzS5qcBKDJ6WNRESu+471z7lEYG9tdgN 1415684250
Message-ID: <1415684245.2486.9.camel@perseus.themaw.net>
Subject: Re: [PATCH 1/3] autofs - fix log print messages
From: Ian Kent <raven@themaw.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 11 Nov 2014 13:37:25 +0800
In-Reply-To: <1415676341.16070.0.camel@perches.com>
References: <20141111012954.25773.4002.stgit@perseus.themaw.net>
	 <1415676341.16070.0.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 19:25 -0800, Joe Perches wrote:
> On Tue, 2014-11-11 at 09:29 +0800, Ian Kent wrote:
> > Fix some inconsistencies in log print output and ensure that
> > the module name is included in all log prints.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > Cc: Joe Perches <joe@perches.com>
> > ---
> >  fs/autofs/autofs_i.h  |    6 +++---
> >  fs/autofs/dev-ioctl.c |    2 +-
> >  fs/autofs/inode.c     |   10 +++++-----
> >  fs/autofs/waitq.c     |    4 ++--
> >  4 files changed, 11 insertions(+), 11 deletions(-)
> 
> What tree are these patches made against?

They live in an StGit patch queue against the current Linus tree.
They depend on the prior series to rename autofs4 to autofs.

Ian

