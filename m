Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411Ab3CMXI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:08:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3CMXI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:08:57 -0400
Date: Wed, 13 Mar 2013 16:08:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
Message-Id: <20130313160854.54ac0491044371b4db214698@linux-foundation.org>
In-Reply-To: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 15:16:24 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Here's another version with the comments addressed plus a small bugfix and some
> checkpatch cleanups.

It all looks nice to my rusty eye.  But then, I like anything which has
comments and passes checkpatch ;)

I see that quite a few people have contributed - have you need getting
enough review and testing feedback?

Either way, I suggest the next step is to ask Stephen to line this up
in linux-next.
