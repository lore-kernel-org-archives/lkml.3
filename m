Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaJHVKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:10:04 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:53089 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaJHVKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:10:02 -0400
Date: Wed, 8 Oct 2014 16:09:56 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: vdso_standalone_test_x86.c build failure on Linus' tree
Message-ID: <20141008160956.7584d303@as>
In-Reply-To: <5435A4A4.1070101@zytor.com>
References: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com>
	<CALCETrUDkHH-FLwq9ZJ0wFeOkQVWUjTh-cJPL4Jq28sHCqhfFA@mail.gmail.com>
	<20141008154659.31f46436@as>
	<5435A4A4.1070101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct 2014 13:55:00 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 10/08/2014 01:46 PM, Chuck Ebbert wrote:
> > 
> > Fedora doesn't cross-compile i686 builds because of problems like
> > this. It sets up an i386 chroot and runs all native tools inside of
> > it.
> > 
> 
> Breaking cross-compilation is not okay, though, regardless of what
> Fedora does.  It should be okay to, for example, build an i386 kernel on
> an ARM box.
> 

I think they tried that for a while, and ended up chasing compiler
and makefile bugs all day. And then there's the software that wants
to run self-tests as part of its build...
