Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaGHVIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:08:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaGHVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:07:59 -0400
Date: Tue, 8 Jul 2014 14:07:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] checkpatch: Add ability to insert and delete lines
 to patch/file
Message-Id: <20140708140758.cc0bcd1d7af956afde149815@linux-foundation.org>
In-Reply-To: <1404853064.932.49.camel@joe-AO725>
References: <cover.1404840958.git.joe@perches.com>
	<678bea67f00c0b59cb17d0e9ee722e0ab0616b43.1404840958.git.joe@perches.com>
	<20140708132409.625c8c90c49b9db9efe6eb8d@linux-foundation.org>
	<1404853064.932.49.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2014 13:57:44 -0700 Joe Perches <joe@perches.com> wrote:

> On Tue, 2014-07-08 at 13:24 -0700, Andrew Morton wrote:
> > On Tue,  8 Jul 2014 10:53:36 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > This can be valuable to insert or delete blank lines as well
> > > as fix misplaced brace or else uses.
> > 
> > hm, do we really want to go down this path?
> 
> Maybe, maybe not.
> 
> I've seen a lot of patches that people seem to spend
> time producing (frequently incorrectly done too) that
> could be better automated.
> 
> > It's a very long one and it leads to /usr/bin/indent?
> 
> For now, I think it's a pretty minimal bit of code.

No strong opinions here.

> I've suggested Lindent be removed from the tree.
> https://lkml.org/lkml/2013/2/11/390

Maybe it's fixable, dunno - I don't recall ever seeing anyone get down
and poke at it.  Of course, indent itself is open source...

