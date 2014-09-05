Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaIEChw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 22:37:52 -0400
Received: from imap.thunk.org ([74.207.234.97]:39110 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbaIEChu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 22:37:50 -0400
Date: Thu, 4 Sep 2014 22:37:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Gioh Kim <gioh.kim@lge.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
        js1304@gmail.com, gunho.lee@lge.com
Subject: Re: [PATCHv4 2/3] ext4: use non-movable memory for the ext4
 superblock
Message-ID: <20140905023736.GB1971@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Gioh Kim <gioh.kim@lge.com>, akpm@linux-foundation.org,
	jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
	peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
	js1304@gmail.com, gunho.lee@lge.com
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <1409815781-28011-3-git-send-email-gioh.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409815781-28011-3-git-send-email-gioh.kim@lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 04:29:40PM +0900, Gioh Kim wrote:
> A buffer-cache for superblock is disturbing page migration,
> because the buffer-cache is not released until unmount.
> The buffer-cache must be allocated from non-movable area.
> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, I've applied this to the ext4 git tree with a slightly
rewritten commit description (for clarity).

						- Ted
