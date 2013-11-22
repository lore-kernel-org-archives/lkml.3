Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3KVQEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:04:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab3KVQEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:04:09 -0500
Date: Fri, 22 Nov 2013 17:04:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Eric Paris <eparis@parisplace.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel
 loading
In-Reply-To: <CACLa4puTT+eP5FkRqLfk60kGzuBLHDC3izzAo5Zewt=QR3QLZw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1311221701510.22082@pobox.suse.cz>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com> <8761rl73s7.fsf@xmission.com> <20131122015518.GA31921@redhat.com> <CAMuHMdUVvhKLBfZo2gBf=FoQxMEM42yzBjYS8r5sVfXgp940ng@mail.gmail.com> <20131122134317.GA4046@redhat.com>
 <CAMuHMdV4=Z8i0u_rWpQU0HHW0mvyv1k-acW1MyT9ZYy=iNwrfg@mail.gmail.com> <alpine.LRH.2.00.1311221631100.9932@twin.jikos.cz> <CACLa4puTT+eP5FkRqLfk60kGzuBLHDC3izzAo5Zewt=QR3QLZw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013, Eric Paris wrote:

> Consider a cloud provider who gives their customer a machine where
> they, the cloud provider, is specifying the kernel and initrd.  This
> is a real thing that people do today.  Root on the machine has ZERO
> control over the kernel, bootloader, and initrd.  Check it out,
> qemu/kvm can do this.  But, there is no way to disable kexec if the
> distro configures it in (well, there is in RHEL at least).  

If that root can load LKMs, access /dev/mem, or whatever else, there is 
not really a point disabling kexec anyway, is the same thing can be 
implemented (although with more hassle, of course) through these channels 
as well.

-- 
Jiri Kosina
SUSE Labs
