Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3FQNHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:07:17 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58643 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888Ab3FQNHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:07:15 -0400
Date: Mon, 17 Jun 2013 09:07:03 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Maarten ter Huurne <maarten@treewalker.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Fixed corruption when online resizing a fs with 1K
 block size
Message-ID: <20130617130703.GD24972@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Maarten ter Huurne <maarten@treewalker.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1367856367-15924-1-git-send-email-maarten@treewalker.org>
 <20130508135825.GA3810@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508135825.GA3810@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 03:58:25PM +0200, Jan Kara wrote:
> On Mon 06-05-13 18:06:07, Maarten ter Huurne wrote:
> > Subtracting the number of the first data block places the superblock
> > backups one block too early, corrupting the file system. When the block
> > size is larger than 1K, the first data block is 0, so the subtraction
> > has no effect and no corruption occurs.
>   Looking where mke2fs places backup super blocks you are right. You can
> add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
