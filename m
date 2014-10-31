Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbaJaJsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:48:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbaJaJsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:48:16 -0400
Date: Fri, 31 Oct 2014 10:48:11 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4 v2] fs: Remove i_devices from struct inode
Message-ID: <20141031094811.GC30321@quack.suse.cz>
References: <1414008853-13200-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414008853-13200-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 22-10-14 22:14:09, Jan Kara wrote:
>   Hello,
> 
>   this patch set removes use of i_devices from block and character device
> code and thus we can remove the list head from struct inode thus saving two
> pointers in it.
> 
> Since v1 I have split the patches and properly handled character devices (I
> broke them last time as Christoph pointed out).
  Any opinion on this guys?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
