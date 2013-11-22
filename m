Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3KVNut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:50:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab3KVNur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:50:47 -0500
Date: Fri, 22 Nov 2013 14:50:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel
 loading
In-Reply-To: <20131122134600.GC4046@redhat.com>
Message-ID: <alpine.LNX.2.00.1311221449120.22082@pobox.suse.cz>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com> <8761rl73s7.fsf@xmission.com> <20131122015518.GA31921@redhat.com> <CAMuHMdUVvhKLBfZo2gBf=FoQxMEM42yzBjYS8r5sVfXgp940ng@mail.gmail.com> <alpine.LRH.2.00.1311221429470.9932@twin.jikos.cz>
 <20131122134600.GC4046@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013, Vivek Goyal wrote:

> > OTOH, does this feature make any sense whatsover on architectures that 
> > don't support secure boot anyway?
> 
> I guess if signed modules makes sense, then being able to kexec signed
> kernel images should make sense too, in general.

Well, that's really a grey zone, I'd say.

In a non-secureboot environment, if you are root, you are able to issue 
reboot into a completely different, self-made kernel anyway, independent 
on whether signed modules are used or not.

-- 
Jiri Kosina
SUSE Labs
