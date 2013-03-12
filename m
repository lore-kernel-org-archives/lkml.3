Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab3CLSEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:04:44 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:55115 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3CLSEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:04:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130311205345.GA9410@Krystal>
References: <20130225152036.GA3405@Krystal>
	<20130311204601.GA22369@kroah.com>
	<20130311205345.GA9410@Krystal>
Date: Tue, 12 Mar 2013 11:04:39 -0700
X-Google-Sender-Auth: ZdvC3oYMpQ8bSfyYoFqWDOZbWFs
Message-ID: <CA+55aFxjw0hhDTaCBW-Gy0EW2WjkfmWPC-QS_iQpZ98-kvuJwA@mail.gmail.com>
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

On Mon, Mar 11, 2013 at 1:53 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Not sure. My guess would be that there is missing proof that I actually
> tested the patch

Well, it was actually mostly that the early patches I saw had very
tentative messages which made me go "Mathieu isn't sure" and kind of
waited for more forceful messages and acks from people. It wasn't
helped by the fact that Al was basically offline for a while.

That said, the patch definitely looks like the right thing to do. I'll apply it.

              Linus
