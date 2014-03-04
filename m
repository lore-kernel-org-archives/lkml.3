Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaCDAHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:07:16 -0500
Received: from science.horizon.com ([71.41.210.146]:56589 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755286AbaCDAHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:07:14 -0500
Date: 3 Mar 2014 19:07:11 -0500
Message-ID: <20140304000711.19992.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@horizon.com
In-Reply-To: <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:
On Mon, Mar 3, 2014 at 1:26 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> Most of the cases have it kept separately in registers, actually - there's
>> a reason why fdget() and friends are inlined.

> Yes. And bit test and set ops on registers are actually cheaper than
> playing around with bytes.

Ah.  I cut & pasted the code into a separate file and compiled it
out of line.  But I stubbed a lot, so it went to memory.  My bad.

> Oh, and George, your email setup is broken. Gmail thinks your emails
> are spam. I'm not sure why (the usual spf problems do not apply), but
> it's possibly because your name and email looks made up.

Thanks, but damn, I wish they'd give a little more information.

The horizon.com MX record is correct, the mail server's forward and
reverse DNS matches, the SMTP server is a little creaky but I think it's
completely standards-compliant.

I'm using bsd mailx, which is *definitely* creaky (you'll notice a
complete lack of MIME or User-Agent headers), but again, it's kind of
the baseline standard for RFC(2)822 e-mail.

The one infelicity I'm aware of is that I cut & pasted the headers from
an on-line mail archive, but mailx doesn't have an easy way to add
an In-Reply-To: header.  Perhaps a Subject: beginning with "Re:" and
no In-Reply-To: looks odd.

But damnifino.
