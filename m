Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab3ICBwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 21:52:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57836 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756821Ab3ICBws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 21:52:48 -0400
Message-ID: <1378173165.1953.148.camel@joe-AO722>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, David Howells <dhowells@redhat.com>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wang Shilong <wangshilong1991@gmail.com>
Date: Mon, 02 Sep 2013 18:52:45 -0700
In-Reply-To: <20130903013408.GA3437@leaf>
References: <20130902195056.GB32628@leaf>
	 <9976.1378132260@warthog.procyon.org.uk>
	 <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf>
	 <20130902181856.GB29787@leaf> <20130902153945.6d7e510c@samsung.com>
	 <1378148367.1953.98.camel@joe-AO722>
	 <13834.1378155023@warthog.procyon.org.uk>
	 <1378156296.1953.117.camel@joe-AO722> <20130903003958.GA6855@localhost>
	 <20130903013408.GA3437@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 18:34 -0700, Josh Triplett wrote:
> I'd suggest a couple more, which
> *should* always make sense, and to the best of my knowledge don't tend
> to generate false positives:
> 
> C99_COMMENTS

I don't have a problem with c99 comments.
As far as I know, Linus doesn't either.

https://lkml.org/lkml/2012/4/16/473

> CONFIG_EXPERIMENTAL
> CVS_KEYWORD

OK, but <shrug>

> ELSE_AFTER_BRACE

I wouldn't do this one.  I think
there are some false positives here.

> GLOBAL_INITIALIZERS
> INITIALISED_STATIC

Nor these.

> INVALID_UTF8
> LINUX_VERSION_CODE
> MISSING_EOF_NEWLINE

OK I suppose.

> PREFER_SEQ_PUTS
> PRINTK_WITHOUT_KERN_LEVEL

There are a lot of these.
I suggest no here.

> RETURN_PARENTHESES
> SIZEOF_PARENTHESIS

It's in coding style, but some newish patches
do avoid them.  It's a question about how noisy
you want your robot to be.

> SPACE_BEFORE_TAB
> TRAILING_SEMICOLON
> TRAILING_WHITESPACE
> USE_DEVICE_INITCALL

> USE_RELATIVE_PATH

Having checkpatch tell people how to write changelogs
I think not a great idea.

> These *ought* to make sense, but I don't know their false positive rates:
> 
> HEXADECIMAL_BOOLEAN_TEST

That's a good one.  0 false positives.

> ALLOC_ARRAY_ARGS

Yes, this would be reasonable too.

> CONSIDER_KSTRTO

I think orobably not.  This would be a cleanup thing.

> CONST_STRUCT

OK

> SPLIT_STRING

I suggest no but <shrug>

