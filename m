Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaBMWhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:37:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaBMWhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:37:14 -0500
Date: Thu, 13 Feb 2014 14:38:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>, Fabian Frederick <fabf@skynet.be>,
        linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
        rdunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 1/1] sys_sysfs: Add CONFIG_SYSFS_SYSCALL
Message-ID: <20140213223832.GA14535@kroah.com>
References: <20140213220942.ff2ebaeff3876b7136fa4b10@skynet.be>
 <20140213223141.GA1232@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213223141.GA1232@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 05:31:41PM -0500, Dave Jones wrote:
> On Thu, Feb 13, 2014 at 10:09:42PM +0800, Fabian Frederick wrote:
>  > sys_sysfs is an obsolete system call no longer supported by libc ...
>  > -This patch adds a default CONFIG_SYSFS_SYSCALL=y
>  > -Option can be turned off in expert mode.
>  > -cond_syscall added to kernel/sys_ni.c
>  > 
>  > Signed-off-by: Fabian Frederick <fabf@skynet.be>
>  > ---
>  >  fs/filesystems.c |  2 ++
>  >  init/Kconfig     | 10 ++++++++++
>  >  kernel/sys_ni.c  |  1 +
>  >  3 files changed, 13 insertions(+)
> 
> did anyone ever ship userspace that actually used that syscall ?
> Some ancient version of udev that probably doesn't work on a modern kernel anyway maybe ?

sys_sysfs doesn't have anything to do with /sys/ and udev in any way
that I know of, it's a much older thing, a sysv syscall that can return
the index, name, or max index of a filesystem.

And yes, I got confused by it all the time when creating sysfs :)

thanks,

greg k-h
