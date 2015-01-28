Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbbA2Bzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:55:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbbA2Bze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:55:34 -0500
Date: Wed, 28 Jan 2015 16:31:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Andy Lutomirski <luto@amacapital.net>, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Edited kexec_load(2) [kexec_file_load()] man page for review
Message-ID: <20150128213125.GH15342@redhat.com>
References: <20141111213037.GA31445@redhat.com>
 <54ADA284.30502@gmail.com>
 <20150112221634.GD16162@redhat.com>
 <54B91271.3000600@gmail.com>
 <20150127142459.GA12851@redhat.com>
 <54C89816.8030709@gmail.com>
 <20150128144803.GC15342@redhat.com>
 <CAKgNAkhhVq5fuqwH0aPdgR1bKkAPPPuS84hfAFg3grGEJNxS4w@mail.gmail.com>
 <20150128203402.GG15342@redhat.com>
 <alpine.DEB.2.11.1501282104490.9275@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501282104490.9275@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 09:14:03PM +0000, Scot Doyle wrote:
> On Wed, 28 Jan 2015, Vivek Goyal wrote:
> > On Wed, Jan 28, 2015 at 04:49:34PM +0100, Michael Kerrisk (man-pages) wrote:
> > > Hello Vivek,
> > > 
> > > >> I've made various adjustments to the page in the light of your comments
> > > >> above. Thanks!
> > > >
> > > > Thank you for following it up and improving kexec man page.
> > > 
> > > You're welcome. So, by now, I've made quite a lot of changes
> > > (including adding a number of cases under ERRORS). I think the revised
> > > kexec_load/kexec_file_load page is pretty much ready to go, but would
> > > you be willing to give the text below a check over first?
> > > 
> > 
> > Hi Michael,
> > 
> > I had a quick look and it looks good to me.
> > 
> > Thanks
> > Vivek
> 
> When I tested, kexec_file_load required CONFIG_RELOCATABLE. Is the same 
> true for kexec_load? Would it make sense to note this in the man pages 
> along with the need for CONFIG_KEXEC_FILE, etc? Or as an error message?

Hmm.., I can't see an explicity dependency between RELOCATABLE and
KEXEC. Both KEXEC and KEXEC_FILE should be able to load a kernel
even if it had RELOCATABLE=n.

Just that kernel will run from the address it has been built for.

Thanks
Vivek
