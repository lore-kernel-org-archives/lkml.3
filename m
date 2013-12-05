Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab3LEDQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 22:16:39 -0500
Received: from ozlabs.org ([203.10.76.45]:47623 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3LEDQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 22:16:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/2] test: add minimal module for verification testing
In-Reply-To: <20131204185619.2edc9d51.akpm@linux-foundation.org>
References: <1386184969-29750-1-git-send-email-keescook@chromium.org> <1386184969-29750-2-git-send-email-keescook@chromium.org> <87li00ow6u.fsf@rustcorp.com.au> <20131204185619.2edc9d51.akpm@linux-foundation.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 05 Dec 2013 13:46:00 +1030
Message-ID: <87haaooumn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> On Thu, 05 Dec 2013 13:12:17 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Kees Cook <keescook@chromium.org> writes:
>> > When doing module loading verification tests (for example, with module
>> > singing, or LSM hooks), it is very handy to have a module that can be
>> 
>> "module singing" sounds like a horrible idea!  Is the author even
>> musical?  I've only heard it said David Howls.
>
> You're such a killjoy.
>
> btw, git log | grep Singed

I had my ego singed off by Linus once, so I completely understand.

Cheers,
Rusty.
