Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3CLWCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:02:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3CLWCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:02:38 -0400
Date: Tue, 12 Mar 2013 15:02:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: ipc/testmsg GPF.
Message-Id: <20130312150236.27ba998a00d31470a2d8aca0@linux-foundation.org>
In-Reply-To: <1363028602.3234.38.camel@thor.lan>
References: <20130307213819.GB19543@redhat.com>
	<1362788821.7755.12.camel@thor.lan>
	<20130311182621.GA24965@redhat.com>
	<1363028602.3234.38.camel@thor.lan>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013 15:03:22 -0400 Peter Hurley <peter@hurleysoftware.com> wrote:

> On Mon, 2013-03-11 at 14:26 -0400, Dave Jones wrote:
> >  > >         {
> > 
> > I just hit this again on rc2 which looks like it has the fixes that
> > Peter mentions above.  This time rdi was 6b6b6b6b6b6b6b7b
> > 
> > 	Dave
> 
> Sorry, Dave. The fix must be in the other 8 patches that Andrew didn't
> want to apply. I run trinity 10 or more times a day and can't get this
> to trigger with the whole series.

Are you able to reproduce the bug with current mainline?
