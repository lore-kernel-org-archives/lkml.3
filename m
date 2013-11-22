Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab3KVNaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:30:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab3KVNaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:30:23 -0500
Date: Fri, 22 Nov 2013 14:30:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel
 loading
In-Reply-To: <CAMuHMdUVvhKLBfZo2gBf=FoQxMEM42yzBjYS8r5sVfXgp940ng@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1311221429470.9932@twin.jikos.cz>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com> <8761rl73s7.fsf@xmission.com> <20131122015518.GA31921@redhat.com> <CAMuHMdUVvhKLBfZo2gBf=FoQxMEM42yzBjYS8r5sVfXgp940ng@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013, Geert Uytterhoeven wrote:

> > Why ELF case is so interesting. I have not use kexec to boot ELF
> > images in years and have not seen others using it too. In fact bzImage
> > seems to be the most common kernel image format for x86, most of the distros
> > ship and use.
> >
> > So first I did the loader for the common use case. There is no reason
> > that one can't write another loader for ELF images. It just bloats
> > the code. Hence I thought that other image loaders can follow slowly. I am
> > not sure why do you say that bzImage is uninteresting.
> 
> Welcome to the non-x86-centric world ;-)
> 
> Looking at kexec-tools, all of arm, cris, i386, ia64, m68k, mips, ppc, ppc64,
> s390, sh, and x86_64 support ELF.
> Only arm, i386, ppc, ppc64, sh, and x86_64 support zImage.
> It's not clear to me what alpha supports (if it supports anything at all?).

OTOH, does this feature make any sense whatsover on architectures that 
don't support secure boot anyway?

-- 
Jiri Kosina
SUSE Labs

