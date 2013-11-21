Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3KUTPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:15:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab3KUTPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:15:17 -0500
Date: Thu, 21 Nov 2013 14:14:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
Message-ID: <20131121191446.GL16208@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <CAMuHMdVoGC3+q2UKvogL=BjkXO3k3Dq9+gGF+7CczG-PJcQPxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVoGC3+q2UKvogL=BjkXO3k3Dq9+gGF+7CczG-PJcQPxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 08:06:02PM +0100, Geert Uytterhoeven wrote:
> On Wed, Nov 20, 2013 at 6:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Now a new system call kexec_file_load() is implemented which takes
> > kernel fd and initrd fd as parameters. Now kernel should be able
> > to verify signature of newly loaded kernel.
> 
> Only kernel fd and initrd fd?
> What about other fds (e.g. device tree, bootinfo)?

Now bootparams and any other stuff is prepared by kernel. So like a
bootloader we just need to know 3 things. Kernel, initrd and command line
and kernel should do the rest.

In future we can define few flags to alter the loading behavior. Like
force 32bit or 16bit entry instead of default 64bit for bzImage.

Thanks
Vivek
