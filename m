Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab3DITnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:43:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934655Ab3DITnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:43:09 -0400
Message-ID: <1365536585.16420.166.camel@bling.home>
Subject: Re: [GIT PULL] vfio fix for 3.9-rc7
From: Alex Williamson <alex.williamson@redhat.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 09 Apr 2013 13:43:05 -0600
In-Reply-To: <CAFLxGvzqFUHDnCimZg1BLfSPxAP=TQcvMfHHyU185k4K+J32KA@mail.gmail.com>
References: <1365534355.16420.160.camel@bling.home>
	 <CAFLxGvzqFUHDnCimZg1BLfSPxAP=TQcvMfHHyU185k4K+J32KA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 21:40 +0200, richard -rw- weinberger wrote:
> On Tue, Apr 9, 2013 at 9:05 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > Hi Linus,
> >
> > Here's one small fix for vfio that I'd like to get in for 3.9;
> > tightening the range checking around a vfio ioctl.  Thanks!
> >
> > Alex
> >
> > The following changes since commit 25e9789ddd9d14a8971f4a421d04f282719ab733:
> >
> >   vfio: include <linux/slab.h> for kmalloc (2013-03-15 12:58:20 -0600)
> >
> > are available in the git repository at:
> >
> >   git://github.com/awilliam/linux-vfio.git tags/vfio-v3.9-rc7
> >
> > for you to fetch changes up to 904c680c7bf016a8619a045850937427f8d7368c:
> >
> >   vfio-pci: Fix possible integer overflow (2013-03-26 11:33:16 -0600)
> 
> Is this commit queued for -stable?
> I don't see a stable tag in the commit message.

No, I forgot to add it.  I'll take the long way around and send it to
stable once it's applied.  Thanks,

Alex

