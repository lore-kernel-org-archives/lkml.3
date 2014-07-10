Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaGJBZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 21:25:09 -0400
Received: from ozlabs.org ([103.22.144.67]:58328 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaGJBZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 21:25:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: modpost: Remove numeric suffix pattern matching
In-Reply-To: <20140709204759.GA32335@ravnborg.org>
References: <1403685999-31013-1-git-send-email-linux@rasmusvillemoes.dk> <53AADC30.7080401@windriver.com> <8761jooaw2.fsf@rasmusvillemoes.dk> <87d2df768c.fsf@rustcorp.com.au> <20140709071319.GA30377@ravnborg.org> <87a98idg2r.fsf_-_@rasmusvillemoes.dk> <20140709204759.GA32335@ravnborg.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 10 Jul 2014 10:44:11 +0930
Message-ID: <8738ea582k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:
> On Wed, Jul 09, 2014 at 11:41:48AM +0200, Rasmus Villemoes wrote:
>> For several years, the pattern "foo$" has effectively been treated as
>> equivalent to "foo" due to a bug in the (misnamed) helper
>> number_prefix(). This hasn't been observed to cause any problems, so
>> remove the broken $ functionality and change all foo$ patterns to foo.
>> 
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> ---
>> Sam, was this what you meant? Otherwise, I'd be more than happy to
>> leave the issue to someone else.
> Exactly - thanks.
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
>
> Rusty - I assume you pick this up and channel it through the module tree.
>
> 	Sam

Done, thanks!

Applied,
Rusty.
