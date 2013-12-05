Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab3LESSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:18:04 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:51475 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab3LESSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:18:01 -0500
MIME-Version: 1.0
In-Reply-To: <87li00ow6u.fsf@rustcorp.com.au>
References: <1386184969-29750-1-git-send-email-keescook@chromium.org>
	<1386184969-29750-2-git-send-email-keescook@chromium.org>
	<87li00ow6u.fsf@rustcorp.com.au>
Date: Thu, 5 Dec 2013 10:18:01 -0800
X-Google-Sender-Auth: Sa1UT-xgdrygNA5i9rfoV022uVY
Message-ID: <CAGXu5j+fF+qURi5xCbM7FDAXiA7-h07e8YwLg5Gbu81ELfXHcA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] test: add minimal module for verification testing
From: Kees Cook <keescook@chromium.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 6:42 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Kees Cook <keescook@chromium.org> writes:
>> When doing module loading verification tests (for example, with module
>> singing, or LSM hooks), it is very handy to have a module that can be
>
> "module singing" sounds like a horrible idea!  Is the author even

Haha, ugh. Yay for typos :)

> musical?  I've only heard it said David Howls.

*rimshot*

> But if my ack for the patch helps:
>
>         Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
