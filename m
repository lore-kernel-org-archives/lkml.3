Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3LECzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:55:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3LECzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:55:21 -0500
Date: Wed, 4 Dec 2013 18:56:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/2] test: add minimal module for verification
 testing
Message-Id: <20131204185619.2edc9d51.akpm@linux-foundation.org>
In-Reply-To: <87li00ow6u.fsf@rustcorp.com.au>
References: <1386184969-29750-1-git-send-email-keescook@chromium.org>
	<1386184969-29750-2-git-send-email-keescook@chromium.org>
	<87li00ow6u.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Dec 2013 13:12:17 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> Kees Cook <keescook@chromium.org> writes:
> > When doing module loading verification tests (for example, with module
> > singing, or LSM hooks), it is very handy to have a module that can be
> 
> "module singing" sounds like a horrible idea!  Is the author even
> musical?  I've only heard it said David Howls.

You're such a killjoy.

btw, git log | grep Singed
