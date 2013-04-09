Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936020Ab3DITkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:40:24 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36987 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934655Ab3DITkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:40:22 -0400
MIME-Version: 1.0
In-Reply-To: <1365534355.16420.160.camel@bling.home>
References: <1365534355.16420.160.camel@bling.home>
Date: Tue, 9 Apr 2013 21:40:21 +0200
Message-ID: <CAFLxGvzqFUHDnCimZg1BLfSPxAP=TQcvMfHHyU185k4K+J32KA@mail.gmail.com>
Subject: Re: [GIT PULL] vfio fix for 3.9-rc7
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 9:05 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> Hi Linus,
>
> Here's one small fix for vfio that I'd like to get in for 3.9;
> tightening the range checking around a vfio ioctl.  Thanks!
>
> Alex
>
> The following changes since commit 25e9789ddd9d14a8971f4a421d04f282719ab733:
>
>   vfio: include <linux/slab.h> for kmalloc (2013-03-15 12:58:20 -0600)
>
> are available in the git repository at:
>
>   git://github.com/awilliam/linux-vfio.git tags/vfio-v3.9-rc7
>
> for you to fetch changes up to 904c680c7bf016a8619a045850937427f8d7368c:
>
>   vfio-pci: Fix possible integer overflow (2013-03-26 11:33:16 -0600)

Is this commit queued for -stable?
I don't see a stable tag in the commit message.

Thanks,
//richard
