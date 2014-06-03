Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaFCFqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:46:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaFCFqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:46:09 -0400
Date: Mon, 2 Jun 2014 22:46:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Driver core / sysfs patches for 3.16-rc1
Message-ID: <20140603054605.GB11565@kroah.com>
References: <20140603054512.GA11565@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603054512.GA11565@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:45:12PM -0700, Greg KH wrote:
> The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:
> 
>   Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.16-rc1
> 
> for you to fetch changes up to cda43576afa641d83ae268cb9795ae2a549d53d9:
> 
>   crypto/nx/nx-842: dev_set_drvdata can no longer fail (2014-05-28 13:39:51 -0700)
> 
> ----------------------------------------------------------------
> Driver core / kernfs pull request for 3.16-rc1
> 
> Here is the "big" pull request for 3.16-rc1.
> Not a lot of changes here, some kernfs work, a revert of a very old
> driver core change that ended up cauing some memory leaks on driver
> probe error paths, and other minor things.
> 
> As was pointed out earlier today, one commit here,
> 26fc9cd200ec839e0b3095e05ae018f27314e7aa (kernfs: move the last
> knowledge of sysfs out from kernfs) is also needed in your 3.15-final
> branch as well.  If you could cherry-pick it there, it would be most
> appreciated by Andy Lutomirski to prevent a regression there.
> 
> All of these have been in linux-next for a while.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ----------------------------------------------------------------
> Fabian Frederick (2):
>       lib/devres.c: use dev in devm_request_and_ioremap
>       lib/devres.c: fix checkpatch warnings
> 
> Greg Kroah-Hartman (2):
>       Merge 3.15-rc3 into staging-next

Note, that merge description was wrong, I merged into driver-core-next
but fat-fingered the message when doing the commit description, sorry
about that.

greg k-h
