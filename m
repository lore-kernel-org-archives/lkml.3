Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbaDBUBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:01:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaDBUBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:01:19 -0400
Date: Wed, 2 Apr 2014 13:03:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: devel@linuxdriverproject.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Staging driver patches for 3.15-rc1
Message-ID: <20140402200341.GD26966@kroah.com>
References: <20140401184817.GA21855@kroah.com>
 <CAKocOOP2E8L1+w0Zik18rnZH+VsvQJNbXymC-7oH+twkDJQKQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOOP2E8L1+w0Zik18rnZH+VsvQJNbXymC-7oH+twkDJQKQg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 07:06:00AM -0600, Shuah Khan wrote:
> On Tue, Apr 1, 2014 at 12:48 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > The following changes since commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15:
> >
> >   Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.15-rc1
> >
> > for you to fetch changes up to 94debda32429e1a348fec8543245f1190a92d68c:
> >
> >   staging: xillybus: XILLYBUS_PCIE depends on PCI_MSI (2014-03-21 12:24:09 -0700)
> >
> > ----------------------------------------------------------------
> > Staging driver pull request for 3.15-rc1
> >
> > Here's the huge drivers/staging/ update for 3.15-rc1.
> >
> > Loads of cleanup fixes, a few drivers removed, and some new ones added.
> >
> > All have been in linux-next for a while.
> >
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> >
> > John de la Garza (3):
> >       staging: usbip: vhci_sysfs.c: check return value of sscanf
> >       comedi:drivers:poc.c: unnecessary space before function pointer arguments
> >       usbip:usbip_common.c: check return value of sscanf
> 
> Please pull in this fix - without this usbip attach will always fail
> with the above scanf return value checks:
> 
> [PATCH v2] staging/usbip: fix store_attach() sscanf return value check
> https://lkml.org/lkml/2014/3/25/178

It's in my queue to apply after 3.15-rc1 is out, thanks.

greg k-h
