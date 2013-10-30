Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab3J3QvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:51:05 -0400
Received: from imap.thunk.org ([74.207.234.97]:52498 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3J3Qu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:50:59 -0400
Date: Wed, 30 Oct 2013 10:55:23 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Azat Khuzhin <a3at.mail@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: drop unsed reclen variable from
 ext4_add_dirent_to_inline()
Message-ID: <20131030145523.GD3305@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Azat Khuzhin <a3at.mail@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
References: <1379535450-31253-1-git-send-email-a3at.mail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379535450-31253-1-git-send-email-a3at.mail@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 12:17:30AM +0400, Azat Khuzhin wrote:
> Functions that need in it, already calculate reclen from namelen by
> themselves:
> - ext4_find_dest_de()
> - ext4_insert_dentry()
> 
> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>

Applied, thanks.

					- Ted
