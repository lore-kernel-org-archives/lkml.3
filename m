Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab3IJW32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:29:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59314 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3IJW31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:29:27 -0400
Date: Tue, 10 Sep 2013 23:29:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20130910222924.GB13318@ZenIV.linux.org.uk>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
 <20130910152753.662599171456233c5f91edb4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910152753.662599171456233c5f91edb4@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 03:27:53PM -0700, Andrew Morton wrote:

> This is rather a fiasco.  "vfs: reorganize dput() memory accesses" made
> rather a mess of a 46 patch series which has been under development and
> test for two cycles so far.

Check vfs.git#for-next...
