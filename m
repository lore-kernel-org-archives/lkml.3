Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbaIENgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:36:21 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:43909 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbaIENgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:36:20 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Fri, 5 Sep 2014 09:36:17 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 17/17] locks: clean up comments over fl_owner_t
 definition
Message-ID: <20140905093617.2eba5693@tlielax.poochiereds.net>
In-Reply-To: <20140904175334.GH16935@infradead.org>
References: <1409834323-7171-1-git-send-email-jlayton@primarydata.com>
	<1409834323-7171-18-git-send-email-jlayton@primarydata.com>
	<20140904175334.GH16935@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014 10:53:34 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Sep 04, 2014 at 08:38:43AM -0400, Jeff Layton wrote:
> > The contents of an fl_owner_t have morphed a bit over the years, fix up
> > the comments to account for the changes.
> 
> Instead of listing all the owners I'd just put something in like:
> 
> /* legacy typedef, will go away soon */

For some definition of "soon" ;)? How about:

   /* legacy typedef, should eventually go away */

I'll change it to read that and probably squash this change in with
another patch.

-- 
Jeff Layton <jlayton@primarydata.com>
