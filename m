Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab3CLSXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:23:46 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:63242 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3CLSXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:23:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxjw0hhDTaCBW-Gy0EW2WjkfmWPC-QS_iQpZ98-kvuJwA@mail.gmail.com>
References: <20130225152036.GA3405@Krystal>
	<20130311204601.GA22369@kroah.com>
	<20130311205345.GA9410@Krystal>
	<CA+55aFxjw0hhDTaCBW-Gy0EW2WjkfmWPC-QS_iQpZ98-kvuJwA@mail.gmail.com>
Date: Tue, 12 Mar 2013 11:23:41 -0700
X-Google-Sender-Auth: st8DJAYNZNhj-p7QJFNvASbYI7U
Message-ID: <CA+55aFy3gTpxzghYL6-Z4wYpubokFdQCYYZQ5tsJAr042uwgHw@mail.gmail.com>
Subject: Re: [PATCH] Fix: compat_rw_copy_check_uvector() misuse in aio, readv,
 writev, and security keys
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Security Officers <security@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:04 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That said, the patch definitely looks like the right thing to do. I'll apply it.

Hmm. I applied it, and then pretty much immediately realized what was
problematic about it. What about the fs/bio.c one?  This all felt like
it was still a work-in-progress, and I'm not sure if you had more
comments or patches coming along?

Anyway, this particular patch got applied. Does that obviate the need
for the fs/bio.c one? I didn't follow all the call-chains...

                   Linus
