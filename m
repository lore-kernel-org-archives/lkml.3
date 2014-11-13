Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaKMDuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 22:50:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60067 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659AbaKMDuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 22:50:11 -0500
X-Sasl-enc: aNfGYo9CwqOBDgqdzFpqWHbvVuVxAzvdEI2aQGZgvB3f 1415850609
Message-ID: <1415850606.2631.19.camel@perseus.themaw.net>
Subject: Re: [PATCH 1/3] autofs - fix log print messages
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 13 Nov 2014 11:50:06 +0800
In-Reply-To: <1415837458.2631.13.camel@perseus.themaw.net>
References: <20141111012954.25773.4002.stgit@perseus.themaw.net>
	 <1415676341.16070.0.camel@perches.com>
	 <1415684245.2486.9.camel@perseus.themaw.net>
	 <1415684989.16070.2.camel@perches.com>
	 <1415685712.2486.17.camel@perseus.themaw.net>
	 <20141112150700.bbb0d82dad1b133fccc1a0ec@linux-foundation.org>
	 <1415837458.2631.13.camel@perseus.themaw.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 08:10 +0800, Ian Kent wrote:
> > 
> > The tree which these patches were based on seem to have more than a
> > plain rename.  For example I get
> 
> Right, looks like something has gone missing along the way. 

Ahh .. I get it now.

> The tree the patches are against is just a local clone of the Linus tree
> with the patches I'd sent previously applied.
> 
> Folding these recent patches into the original series and sending one
> series only that applies on the current Linus tree should sort out the
> problem.
> 
> > 
> > --- fs/autofs4/autofs_i.h
> > +++ fs/autofs4/autofs_i.h

Looks like the patches I sent on 3rd Dec, which is what Joe commented
on, were missed.

It's probably better for me to start over once its decided how I'll be
sending the patches.

Ian


