Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaBWWPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:15:18 -0500
Received: from imap.thunk.org ([74.207.234.97]:33166 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbaBWWPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:15:17 -0500
Date: Sun, 23 Feb 2014 17:15:13 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/ext4/inode.c: Add unlikely() to ext4_iget
Message-ID: <20140223221513.GA27617@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fabian Frederick <fabf@skynet.be>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>
References: <20140223200115.cd49762996b6bac6cbdd47bc@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140223200115.cd49762996b6bac6cbdd47bc@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 08:01:15PM +0100, Fabian Frederick wrote:
> Isolate no memory and bad inode cases in ext4_iget.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Does this result in a measurable performance difference?

     	  	      		 	     - Ted
