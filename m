Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaDOUGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:06:47 -0400
Received: from imap.thunk.org ([74.207.234.97]:54751 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbaDOUGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:06:31 -0400
Date: Tue, 15 Apr 2014 16:06:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][6/11][MANUX] Kernel compatibility : directory hardlinks
Message-ID: <20140415200629.GI4456@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Emmanuel Colbus <ecolbus@manux.info>, linux-kernel@vger.kernel.org
References: <534D3765.4090403@manux.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D3765.4090403@manux.info>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:43:01PM +0200, Emmanuel Colbus wrote:
> Now for something that has to do both with syscalls and filesystems...
> 
> My operating system relies heavily upon hardlinks, and, amongst others,
> directory hardlinks. (Yes, that's what my ext2l partitions are for. Not
> only, but this is part of it).
> 
> To allow distinguishing them from true directories, I've introduced a
> value S_IFDHL equal to 0130000, both for the file mode in stat(2) and
> for the type_entry field in the dirent structure, in getdents64(2).

Not without more information about what the value means, and what it
would be used for.  See my previous comments about why reserving code
points for random personal projects is not a something which is at all
scalable.

						- Ted
