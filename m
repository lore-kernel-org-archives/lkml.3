Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaF3XjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 19:39:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaF3XjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 19:39:11 -0400
Date: Mon, 30 Jun 2014 16:39:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] fs.h: Remove unnecessary extern prototypes
Message-Id: <20140630163909.9859f3c55406746129a69e77@linux-foundation.org>
In-Reply-To: <1404171091.2717.24.camel@joe-AO725>
References: <cover.1403999769.git.joe@perches.com>
	<c81908e88f71ca2c21a8e3eaf3e5f72bd8d6c322.1403999769.git.joe@perches.com>
	<20140630161944.bd57016cba11f47185dbe6c5@linux-foundation.org>
	<1404171091.2717.24.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 16:31:31 -0700 Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-06-30 at 16:19 -0700, Andrew Morton wrote:
> > On Sat, 28 Jun 2014 17:20:13 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > This file has a mixture of prototypes with and without extern.
> > > Remove the extern uses.
> > 
> > urgh, it's been two days and this already throws a huge reject.  I fix
> > that and the other two patches throw great piles of rejects as well.
> > 
> > Dunno.  Maybe `diff -u1' will make it feasible.
> 
> This was against -next and was done almost completely
> by automated tool.

Ah, didn't know that.

I get the same issues with current -next.

> I can fix it and resubmit if you like.

OK.  How about we wait for -rc6 or thereabouts?  That should minimise
the pain profile.

