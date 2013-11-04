Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3KDDLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:11:18 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:59311 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3KDDLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:11:17 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
Date: Sun, 3 Nov 2013 19:11:16 -0800
Message-ID: <CA+8MBbJeQNBo=W1Gu2bBDQ83e0r3Omc3FdJjjGbxrAi0NM61Ww@mail.gmail.com>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 3, 2013 at 4:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> And the reason I mention "4.0" is that it would be a lovely time to do
> that. Roughly a years heads-up that "ok, after 3.19 (or whatever),
> we're doing a release with *just* fixes, and then that becomes 4.0".
>
> Comments?

Unless you are planning to kick out releases significantly faster
than you have over the past few years ... then "roughly a year"
and "3.19" don't really match up. 3.17 would be a better guess.

This means you are ignoring the Knuth-ites who think 3.14 should
be followed by 3.141, 3.1415, 3.14159 etc. :-)

What would the rules look like for a "fixes-only" release? With
no merge window of new stuff would you enforce a "nothing
except regressions" policy after -rcN (for N >=3).  That might
feel odd in a fixes release to tell someone that their fix isn't
going to be taken.  But we all want the fixes release to converge
quickly so we can return to "ooh shiny" stuff - so "too big,
too late" should probably still be the rule.

Perhaps all the bugs to be fixed need to be logged in
bugzilla.kernel.org with some "for 4.0" tag by the
start of this fixes window - then we'd have some bound
on the release criteria for 4.0?

-Tony
