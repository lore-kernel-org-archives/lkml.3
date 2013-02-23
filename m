Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab3BWAa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 19:30:29 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:40021 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab3BWAa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 19:30:26 -0500
MIME-Version: 1.0
In-Reply-To: <9798783.W2ijE8Yd31@vostro.rjw.lan>
References: <20130222085954.GA4352@redhat.com>
	<20130222215158.GA4723@balto.lan>
	<9798783.W2ijE8Yd31@vostro.rjw.lan>
Date: Fri, 22 Feb 2013 16:30:25 -0800
X-Google-Sender-Auth: ri-ytBVkPdhTBxsgRpnlQQkIN_U
Message-ID: <CA+55aFxcqczXZf7zxJ0xjDsnLMbS8uu9Jp5BDOdnR5tqf==nrA@mail.gmail.com>
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>, Dave Jones <davej@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, tianyu.lan@intel.com,
        Linux ACPI <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 4:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> It won't revert, there's more stuff on top of it.  And it is a fix, so
> reverting it is not really a good idea anyway.

Rafael, please don't *ever* write that crap again.

We revert stuff whether it "fixed" something else or not. The rule is
"NO REGRESSIONS". It doesn't matter one whit if something "fixes"
something else or not - if it breaks an old case, it gets reverted.

Seriously. Why do I even have to mention this? Why do I have to
explain this to somebody pretty much *every* f*cking merge window?

This is not a new rule.

And btw, the *reason* for that rule becoming such a hard rule was
pretty much exactly suspend/resume and ACPI. Exactly because we used
to have those infinite "let's fix one thing and break another" dances.
So you should be well acquainted with the rule, and I'm surprised to
hear that kind of utter garbage from you in particular.

There is no excuse for regressions, and "it is a fix" is actually the
_least_ valid of all reasons.

A commit that causes a regression is - by definition - not a "fix". So
please don't *ever* say something that stupid again.

Things that used to work are simply a million times more important
than things that historically didn't work.

So this had better get fixed asap, and I need to feel like people are
working on it. Otherwise we start reverting.

And no amount "but it's a fix" matters one whit. In fact, it just
makes me feel like I need to start reverting early, because the
maintainer doesn't seem to understand how serious a regression is.

                  Linus
