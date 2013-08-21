Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3HUUAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:00:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38998 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab3HUUAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:00:37 -0400
Date: Wed, 21 Aug 2013 22:00:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821200034.GA10671@nazgul.tnic>
References: <20130820224032.GA20491@kroah.com>
 <521504D7.7090204@wwwdotorg.org>
 <CA+55aFxMkQoJAJd2=XyJu0NX2dG3mX=obx=YL6YXatLg4S=-Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFxMkQoJAJd2=XyJu0NX2dG3mX=obx=YL6YXatLg4S=-Vw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:36:05AM -0700, Linus Torvalds wrote:
> Will it catch all cases? Hell no. We don't have *that* many people who
> run git kernels, and even people who do don't tend to update daily
> anyway.

We don't want to run daily snapshots of your tree though, right? Only
-rcs because the daily states are kinda arbitrary and they can be broken
in various ways. Or are we at a point in time where we can amend that
rule?

For example, what I do currently is, I take your -rcX something and
merge tip/master ontop of it and this is running on my machines for that
week. Come next week, I rinse and repeat. Or does it make sense to do
that more than once a week?

Thanks.
