Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab3BHDK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:10:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52589 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3BHDK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:10:27 -0500
Date: Fri, 8 Feb 2013 03:10:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jaegeuk.kim@samsung.com,
        "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>
Subject: Re: [GIT PULL] f2fs fixes for v3.8-rc7
Message-ID: <20130208031021.GF4503@ZenIV.linux.org.uk>
References: <1360196464.26950.65.camel@kjgkr>
 <CA+55aFzygotc-rGOBwHmdXU6KrpCE7srqWYs6j-iP5c5Ef3UnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzygotc-rGOBwHmdXU6KrpCE7srqWYs6j-iP5c5Ef3UnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 12:09:34PM +1100, Linus Torvalds wrote:
> No.
> 
> You guys need to realize that I'm not talking crap like this this late.
> 
> This is not major bugfixes. I already looked away once just because
> it's a new filesystem, but enough is enough. This is way way WAY too
> late to start sendign "enhancements". Seriously.
> 
> Send them for the next merge window. Not just before rc7.

BTW, for the next merge window I've got several patches to that sucker;
commits f3d9d7e..10e4e72 in vfs.git.  I can send them to f2fs tree or
have them go in vfs one, but this stuff needs to be dealt with.  Fake
struct dentry on stack is a bad thing with capital Hell No...
