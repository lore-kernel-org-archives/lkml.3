Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaKDKBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:01:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbaKDKBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:01:46 -0500
Date: Tue, 4 Nov 2014 11:01:41 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] chardev: Increment cdev reference count when i_cdev
 references it
Message-ID: <20141104100141.GC2953@quack.suse.cz>
References: <1414008853-13200-1-git-send-email-jack@suse.cz>
 <1414008853-13200-3-git-send-email-jack@suse.cz>
 <20141104095258.GB17722@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104095258.GB17722@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-11-14 10:52:58, Christoph Hellwig wrote:
> On Wed, Oct 22, 2014 at 10:14:11PM +0200, Jan Kara wrote:
> > Currently i_cdev reference to a character device isn't accounted in the
> > reference count of the character device. This then requires us to track
> > all references through a list of all inodes referencing a character
> > device which is somewhat clumsy and requires list_head in each inode in
> > the system.
> > 
> > So make i_cdev a reference like any other.
> 
> Looks good.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
  Thanks for review.

> Maybe you can rename the new variable to something like to_put also?
  Yes, that's better. Done.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
