Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab3J3S3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:29:11 -0400
Received: from imap.thunk.org ([74.207.234.97]:52569 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab3J3S3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:29:09 -0400
Date: Wed, 30 Oct 2013 14:29:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Azat Khuzhin <a3at.mail@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: drop unsed reclen variable from
 ext4_add_dirent_to_inline()
Message-ID: <20131030182904.GA31683@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Azat Khuzhin <a3at.mail@gmail.com>,
	open list <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
References: <1379535450-31253-1-git-send-email-a3at.mail@gmail.com>
 <20131030145523.GD3305@thunk.org>
 <CAG5DWoi5DRCTos8-9aiLVEMf9SFc293nPj4bS0Sq6EdGsOqeYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG5DWoi5DRCTos8-9aiLVEMf9SFc293nPj4bS0Sq6EdGsOqeYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 09:02:35PM +0400, Azat Khuzhin wrote:
> 
> Thank you!
> But there is a typo in subject, s/unsed/unused/ could you fix or it,
> or tell me, and I will resend it?

I had already reworeded the commit description as follows:

    ext4: drop set but otherwise unused variable from ext4_add_dirent_to_inline()
    
    Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Cheers,

						- Ted
