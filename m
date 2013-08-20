Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3HTQde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:33:34 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:62611 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3HTQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:33:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130820155735.GA2805@kroah.com>
References: <20130820155735.GA2805@kroah.com>
Date: Tue, 20 Aug 2013 09:33:30 -0700
X-Google-Sender-Auth: JvPqTPLMOfo9va_7_5fStG_RI7U
Message-ID: <CA+55aFxrPP8=xPWuRVy0HPyiFkT8Mc03zWGKosg+WrEQfqNDfQ@mail.gmail.com>
Subject: Re: Linux 3.0.92
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 8:57 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Johannes Berg (1):
>       genetlink: fix family dump race

This one turns out to be buggy, see thread called "3.11-rc6 genetlink
locking fix offends lockdep".

I really think there should be delay before stable picks up stuff from
mainline, unless it's something particularly critical and
well-discussed.. Maybe a week or so.

Now it's both in 3.0 and 3.10, so the revert (unless we find a better
fix - and the first two patches have already failed) will have to go
there too.

                   Linus
