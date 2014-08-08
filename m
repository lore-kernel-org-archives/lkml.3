Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbaHHJXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:23:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbaHHJXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:23:01 -0400
Date: Fri, 8 Aug 2014 11:22:56 +0200
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jan Kara <jack@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ext3 tree
Message-ID: <20140808092256.GB2398@quack.suse.cz>
References: <20140808115226.3f4fbeb7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808115226.3f4fbeb7@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-08-14 11:52:26, Stephen Rothwell wrote:
> Hi Jan,
> 
> After merging the ext3 tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "new_inode_pseudo" [fs/reiserfs/reiserfs.ko] undefined!
> 
> Caused by commit 523096294315 ("reiserfs: Avoid warning from unlock_new_inode()").
> 
> I have used the ext3 tree from next-20140807 for today.
  Ah, sorry. Somehow I've pushed out old version of that commit. I'll fix
that up.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
