Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3KVQJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:09:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726Ab3KVQJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:09:10 -0500
Date: Fri, 22 Nov 2013 11:08:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Eric Paris <eparis@parisplace.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
Message-ID: <20131122160837.GJ4046@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <8761rl73s7.fsf@xmission.com>
 <20131122015518.GA31921@redhat.com>
 <CAMuHMdUVvhKLBfZo2gBf=FoQxMEM42yzBjYS8r5sVfXgp940ng@mail.gmail.com>
 <20131122134317.GA4046@redhat.com>
 <CAMuHMdV4=Z8i0u_rWpQU0HHW0mvyv1k-acW1MyT9ZYy=iNwrfg@mail.gmail.com>
 <alpine.LRH.2.00.1311221631100.9932@twin.jikos.cz>
 <CACLa4puTT+eP5FkRqLfk60kGzuBLHDC3izzAo5Zewt=QR3QLZw@mail.gmail.com>
 <alpine.LNX.2.00.1311221701510.22082@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1311221701510.22082@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 05:04:04PM +0100, Jiri Kosina wrote:
> On Fri, 22 Nov 2013, Eric Paris wrote:
> 
> > Consider a cloud provider who gives their customer a machine where
> > they, the cloud provider, is specifying the kernel and initrd.  This
> > is a real thing that people do today.  Root on the machine has ZERO
> > control over the kernel, bootloader, and initrd.  Check it out,
> > qemu/kvm can do this.  But, there is no way to disable kexec if the
> > distro configures it in (well, there is in RHEL at least).  
> 
> If that root can load LKMs, access /dev/mem, or whatever else, there is 
> not really a point disabling kexec anyway, is the same thing can be 
> implemented (although with more hassle, of course) through these channels 
> as well.

I am assuming that in above scenario, kernel will run in locked down
mode (something what matthew implemented for secureboot). Where /dev/mem
write access will be disabled and only signed modules will be loaded.

Thanks
Vivek
