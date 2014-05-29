Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbaE2RPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:15:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758027AbaE2RPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:15:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com>
References: <CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk>
To: sedat.dilek@gmail.com
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Felix Fietkau <nbd@openwrt.org>, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        mszeredi@suse.cz
Subject: Re: Unionmount and overlayfs testsuite
Date: Thu, 29 May 2014 18:15:05 +0100
Message-ID: <29026.1401383705@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> wrote:

> # grep LOCKDEP /boot/config-3.15.0-rc7-58.1-iniza-small
> CONFIG_LOCKDEP_SUPPORT=y

That's not LOCKDEP, merely support for it.  What I see:

	warthog>grep LOCKDEP build/.config
	CONFIG_LOCKDEP_SUPPORT=y
	CONFIG_LOCKDEP=y

> ./tool_box.inc: line 144: /usr/local/bin/open-file: No such file or directory

Did you follow this step in the README file?

	(2) Copy fs-op and open-file to /usr/local/bin/

David
