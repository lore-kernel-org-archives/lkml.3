Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab3E1Lx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:53:58 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52521 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225Ab3E1Lx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:53:57 -0400
Date: Tue, 28 May 2013 07:53:52 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Paul Taysom <taysom@chromium.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org
Subject: Re: [PATCH] fs: ext4: Printing debug is now configurable
Message-ID: <20130528115352.GD11839@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Paul Taysom <taysom@chromium.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	olofj@chromium.org
References: <1367358660-940-1-git-send-email-taysom@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367358660-940-1-git-send-email-taysom@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 02:51:00PM -0700, Paul Taysom wrote:
> Printing the "truncating inode" and "deleting unreferenced inode"
> messages is now controlled by the "debug" option to mount.
> These messages were filling the /var/log/messages file and
> are normal for ext4 file system recovery.
> 
> Tested by opening several files, unlinking them, then
> crashing the system, rebooting the system and examining
> /var/log/messages.
> 
> Addresses the problem described in http://crbug.com/220976
> 
> Signed-off-by: Paul Taysom <taysom@chromium.org>

Added to the ext4 patch queue with a slightly modified description.
(Sorry for the delay, you sent the patch just as the merge window had
starting, and I wasn't accepting new until the tree had settled down.)

	      	       		     - Ted
