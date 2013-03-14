Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab3CNNng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:43:36 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:53843 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840Ab3CNNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:43:34 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130313160854.54ac0491044371b4db214698@linux-foundation.org>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<20130313160854.54ac0491044371b4db214698@linux-foundation.org>
Date: Thu, 14 Mar 2013 14:43:32 +0100
Message-ID: <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 12:08 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 13 Mar 2013 15:16:24 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> Here's another version with the comments addressed plus a small bugfix and some
>> checkpatch cleanups.
>
> It all looks nice to my rusty eye.  But then, I like anything which has
> comments and passes checkpatch ;)
>
> I see that quite a few people have contributed - have you need getting
> enough review and testing feedback?

Well, testing feedback I got plenty when it was all new and full of
bugs. Now I don't get much.  All I usually get nowdays is people
asking why is it not in mainline yet.

> Either way, I suggest the next step is to ask Stephen to line this up
> in linux-next.

Al, are you okay with that?  Or do you want it to go though -vfs?

Thanks,
Miklos
