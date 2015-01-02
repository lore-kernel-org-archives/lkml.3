Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbbABS7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:59:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbbABS7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:59:33 -0500
Date: Fri, 2 Jan 2015 13:59:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kexec: Fix a typo in comment
Message-ID: <20150102185907.GB3733@redhat.com>
References: <1420221379-4553-1-git-send-email-kuleshovmail@gmail.com>
 <87vbkpvx0s.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbkpvx0s.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 12:48:51PM -0600, Eric W. Biederman wrote:
> Alexander Kuleshov <kuleshovmail@gmail.com> writes:
> 
> > Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

[ CC akpm ]

Simple fix.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> 
> > ---
> >  kernel/kexec.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/kexec.c b/kernel/kexec.c
> > index 9a8a01a..75a8b7e 100644
> > --- a/kernel/kexec.c
> > +++ b/kernel/kexec.c
> > @@ -444,7 +444,7 @@ arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
> >  }
> >  
> >  /*
> > - * Free up memory used by kernel, initrd, and comand line. This is temporary
> > + * Free up memory used by kernel, initrd, and command line. This is temporary
> >   * memory allocation which is not needed any more after these buffers have
> >   * been loaded into separate segments and have been copied elsewhere.
> >   */
