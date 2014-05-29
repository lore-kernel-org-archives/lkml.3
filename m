Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaE2SYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:24:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbaE2SYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:24:04 -0400
Date: Thu, 29 May 2014 14:23:18 -0400
From: Dave Jones <davej@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: sedat.dilek@gmail.com, Miklos Szeredi <miklos@szeredi.hu>,
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
Message-ID: <20140529182318.GA6607@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Howells <dhowells@redhat.com>, sedat.dilek@gmail.com,
	Miklos Szeredi <miklos@szeredi.hu>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
	Felix Fietkau <nbd@openwrt.org>, neilb@suse.de,
	jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
	"J. R. Okajima" <hooanon05@yahoo.co.jp>, mszeredi@suse.cz
References: <CA+icZUWeyh3GEUr9+naecGVECUp4mXNQuOuj--r78f2f5UdgdA@mail.gmail.com>
 <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
 <28592.1401382081@warthog.procyon.org.uk>
 <CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com>
 <29026.1401383705@warthog.procyon.org.uk>
 <31514.1401385803@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31514.1401385803@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 06:50:03PM +0100, David Howells wrote:
 > Sedat Dilek <sedat.dilek@gmail.com> wrote:
 > 
 > > config LOCKDEP
 > >         bool
 > 
 > It has no name, so you can't turn it on manually.  You have to enable
 > something the depends on or selects it.
 > 
 > Turn on:
 > 
 > 	CONFIG_DEBUG_ATOMIC_SLEEP=y
 > 	CONFIG_DEBUG_LOCK_ALLOC=y
 > 	CONFIG_DEBUG_MUTEXES=y
 > 	CONFIG_DEBUG_RT_MUTEXES=y
 > 	CONFIG_DEBUG_SPINLOCK=y

The more interesting parts of lockdep come under CONFIG_PROVE_LOCKING

	Dave
 
