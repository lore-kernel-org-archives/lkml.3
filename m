Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938AbaDODhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:37:42 -0400
Received: from imap.thunk.org ([74.207.234.97]:54407 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaDODhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:37:41 -0400
Date: Mon, 14 Apr 2014 23:37:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Azat Khuzhin <a3at.mail@gmail.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: fix ext4_count_free_clusters() with EXT4FS_DEBUG
 and bigalloc enabled
Message-ID: <20140415033738.GB3403@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Azat Khuzhin <a3at.mail@gmail.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	open list <linux-kernel@vger.kernel.org>
References: <1397492316-12237-1-git-send-email-a3at.mail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397492316-12237-1-git-send-email-a3at.mail@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 08:18:36PM +0400, Azat Khuzhin wrote:
> With bigalloc enabled we must use EXT4_CLUSTERS_PER_GROUP() instead of
> EXT4_BLOCKS_PER_GROUP() otherwise we will go beyond the allocated buffer.

You forgot the signed-off-by, since it's a one-line patch, I'll apply it.  Thanks!

    	       		      	    	   - Ted
