Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3IJWoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:44:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3IJWoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:44:01 -0400
Date: Tue, 10 Sep 2013 15:44:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130910154400.75bb3328fbb9eaa937715652@linux-foundation.org>
In-Reply-To: <CA+55aFwiK+=7N3EDoX+s8dVCoraba9bCPrgqHgsMKppogEFBnw@mail.gmail.com>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
	<20130910152753.662599171456233c5f91edb4@linux-foundation.org>
	<CA+55aFwiK+=7N3EDoX+s8dVCoraba9bCPrgqHgsMKppogEFBnw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013 15:35:04 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I'd (once again) suggest you base your pile of patches on the
> previous stable kernel, and that linux-next take it *first* rather
> than take it last.

That's what we're now doing.  But this particular patchset was
different because it's changing multiple subsystems, several of which
are concurrently being changed in an uncoordinated fashion.
