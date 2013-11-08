Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3KHB0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 20:26:47 -0500
Received: from ozlabs.org ([203.10.76.45]:57016 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab3KHB0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 20:26:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [trivial PATCH] module.h: Remove unnecessary semicolon
In-Reply-To: <1383868777.9263.39.camel@joe-AO722>
References: <1383685095.4387.45.camel@joe-AO722> <87zjph55px.fsf@rustcorp.com.au> <1383800991.7940.51.camel@joe-AO722> <877gcj6c3v.fsf@rustcorp.com.au> <1383868777.9263.39.camel@joe-AO722>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 08 Nov 2013 11:56:12 +1030
Message-ID: <87bo1v4rbf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> On Fri, 2013-11-08 at 09:41 +1030, Rusty Russell wrote:
>> Joe Perches <joe@perches.com> writes:
>> > That's a trust issue.
>> > I've done it.  It isn't necessary.
>> 
>> WTF?  Now you just said it's not necessary, I *know* I can't trust you.
>
> "It" in this case is the grep that I did
> prior to sending the patch.

Hi Joe,

Apologies for my off tone.  But I think we got tangled somewhere?

You said "It isn't necessary".

You maintain that grepping the source to find out if you'd broken
something "isn't necessary"?

git history shows me you've done lots of these cleanups.  I'm pretty
sure that's not what you meant.

But as maintainer, it's annoying that I had to check myself.  I don't
have personal experience in how diligent you are.  If you'd just
mentioned it, it would have saved me a few minutes and streamlined my
workflow immensely. 

Providing assurance makes me a happy maintainer.  So I modified it
because it sets a clear example for others.

I hope that clarifies,
Rusty.
