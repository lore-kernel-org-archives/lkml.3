Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3IJWf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:35:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3IJWfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:35:22 -0400
Date: Tue, 10 Sep 2013 15:35:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
In-Reply-To: <20130910222924.GB13318@ZenIV.linux.org.uk>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
	<20130910152753.662599171456233c5f91edb4@linux-foundation.org>
	<20130910222924.GB13318@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013 23:29:24 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Tue, Sep 10, 2013 at 03:27:53PM -0700, Andrew Morton wrote:
> 
> > This is rather a fiasco.  "vfs: reorganize dput() memory accesses" made
> > rather a mess of a 46 patch series which has been under development and
> > test for two cycles so far.
> 
> Check vfs.git#for-next...

Why?  What is in it?
