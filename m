Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3J2N71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:59:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab3J2N7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:59:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <526FA1B7.4090808@asianux.com>
References: <526FA1B7.4090808@asianux.com> <526F09B8.9030202@asianux.com> <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com> <24899.1383043169@warthog.procyon.org.uk>
To: Chen Gang <gang.chen@asianux.com>
Cc: dhowells@redhat.com, Vineet Gupta <vineetg76@gmail.com>,
        James Hogan <james.hogan@imgtec.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] arch: use ASM_NL instead of ';' for assembler new line character in the macro
Date: Tue, 29 Oct 2013 13:59:07 +0000
Message-ID: <26752.1383055147@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> wrote:

> >> > For "kernel/modsign_certificate.S", I recommend to expand the macro
> >> > which will shrink code line, either need not include additional header
> >> > file, I feel that will be simpler for both code reader and writers.
> > I recommend leaving that file alone.  That gets moved to a .S file in patches
> > queued in the security tree.
> 
> Excuse me, I am not quite familiar with our version merging, I guess
> your meaning is "this file will be removed, and the related contents
> will be in another .S file, so we need not fix it within this file".
> 
> If what I guess is correct, I support your recommendation (and if what I
> guess is incorrect, please let me know, thanks). :-)

Sorry, I misread what you were saying.  The code has already been split out of
the .c file of course (I'd forgotten that it had).  In the security tree next
branch, the .S file gets renamed and slightly modified here:

	http://git.kernel.org/cgit/linux/kernel/git/jmorris/linux-security.git/commit/?h=next&id=b56e5a17b6b9acd16997960504b9940d0d7984e7

David
