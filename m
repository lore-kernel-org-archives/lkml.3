Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaKDMJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:09:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbaKDL6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:58:25 -0500
Date: Tue, 4 Nov 2014 11:59:22 +0100
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Anton Blanchard <anton@samba.org>, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] quota: Add log level to printk
Message-ID: <20141104105922.GD2953@quack.suse.cz>
References: <20141104120501.0318cc7d@kryten>
 <1415070399.17743.49.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415070399.17743.49.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 03-11-14 19:06:39, Joe Perches wrote:
> On Tue, 2014-11-04 at 12:05 +1100, Anton Blanchard wrote:
> > Signed-off-by: Anton Blanchard <anton@samba.org>
> > ---
> > 
> > Index: b/fs/quota/dquot.c
> > ===================================================================
> > --- a/fs/quota/dquot.c
> > +++ b/fs/quota/dquot.c
> > @@ -2743,7 +2743,7 @@ static int __init dquot_init(void)
> >  	for (i = 0; i < nr_hash; i++)
> >  		INIT_HLIST_HEAD(dquot_hash + i);
> >  
> > -	printk("Dquot-cache hash table entries: %ld (order %ld, %ld bytes)\n",
> > +	pr_info("Dquot-cache hash table entries: %ld (order %ld, %ld bytes)\n",
> >  			nr_hash, order, (PAGE_SIZE << order));
> 
> The other printks in the file have a "VFS: " prefix.
> Maybe this one too?
  I'll merge Anton's patch and include additional VFS:.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
