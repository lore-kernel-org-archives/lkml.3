Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3CMXG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:06:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3CMXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:06:26 -0400
Date: Wed, 13 Mar 2013 16:06:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 8/9] overlay: overlay filesystem documentation
Message-Id: <20130313160623.52ec76cd5239c791b59828b8@linux-foundation.org>
In-Reply-To: <1363184193-1796-9-git-send-email-miklos@szeredi.hu>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-9-git-send-email-miklos@szeredi.hu>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 15:16:32 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Neil Brown <neilb@suse.de>
> 
> Document the overlay filesystem.
> 

Damn, I did it again.  This is good, thanks.

> +Changes to the underlying filesystems while part of a mounted overlay
> +filesystem are not allowed.  If the underlying filesystem is changed,
> +the behavior of the overlay is undefined, though it will not result in
> +a crash or deadlock.

ah-hah, there it is.  I was wondering how this can-o-worms would be
handled ;)

Is there anything in place to enforce this at runtime?  Checks for
read-onlyness, code to prevent rw remounts, etc?

