Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856AbaGQP1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:27:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804AbaGQP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:26:58 -0400
Date: Thu, 17 Jul 2014 08:26:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.16-rc4
Message-ID: <20140717152657.GA26348@kroah.com>
References: <1404153635-10868-1-git-send-email-balbi@ti.com>
 <20140701045957.GA17105@kroah.com>
 <20140717150856.GH10459@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717150856.GH10459@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:08:56AM -0500, Felipe Balbi wrote:
> On Mon, Jun 30, 2014 at 09:59:57PM -0700, Greg KH wrote:
> > On Mon, Jun 30, 2014 at 01:40:35PM -0500, Felipe Balbi wrote:
> > > Hi Greg,
> > > 
> > > Here's my second set of fixes. Note the revert of the patch Michal
> > > asked to revert.
> > > 
> > > Please consider merging to your usb-linus branch. Let me know if you
> > > want any changes to this pull request.
> > > 
> > > cheers
> > > 
> > > 
> > > The following changes since commit 5d881802c407d83c169c875dad88fe2bba066c33:
> > > 
> > >   usb: musb: core: Handle Babble condition only in HOST mode (2014-06-19 15:43:07 -0500)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.16-rc4
> > 
> > Pulled and pushed out, thanks.
> 
> looks like this is still pending and I can't find them either in
> mainline nor in any of your branches.

Really?  I just did a pull and they all seem to be in Linus's tree for
3.16-rc5 for me:

~/linux/work/usb $ git b
  master     1795cd9b3a91 Linux 3.16-rc5
  usb-linus  1795cd9b3a91 Linux 3.16-rc5
  usb-next   46865bf3d6b4 Merge tag 'usb-serial-3.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/johan/usb-serial into usb-next
* work-linus 1795cd9b3a91 Linux 3.16-rc5
  work-next  46865bf3d6b4 Merge tag 'usb-serial-3.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/johan/usb-serial into usb-next
~/linux/work/usb $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.16-rc4 
remote: Counting objects: 1, done.
remote: Total 1 (delta 0), reused 1 (delta 0)
Unpacking objects: 100% (1/1), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb
 * tag                         fixes-for-v3.16-rc4 -> FETCH_HEAD
Already up-to-date.


So even if I wanted to pull these again, I couldn't :)

Take another look...

thanks,

greg k-h
