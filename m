Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbbADVCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 16:02:19 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60603 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbbADVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 16:02:18 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
References: <20150104190123.GA20153@amd>
	<alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
	<20150104201026.GA23427@amd>
	<alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
	<20150104203724.GA16372@amd>
	<alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
Date: Sun, 4 Jan 2015 13:02:17 -0800
X-Google-Sender-Auth: 9P1yLo5XANwcWRd9_HsekKfB7oE
Message-ID: <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 12:56 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>
> It wasted a lot of people's time before by simply being there and wrong
> before it was removed.  It's only a matter of whose time you want to
> waste.  Really.

Really. Shut up.

The whole "no regressions" thing is very much about the fact that we
don't waste users time.

We want users to be able to upgrade their kernels, and feel safe in
knowing that we as kernel developers did our best - including very
much "spending our time" - to make sure that users don't have to waste
time.

And if you aren't ok with "wasting time" on trying to give that kind
of reassurances to users, then you shouldn't be working on the kernel.

I'm serious about this. You really *need* to understand that.  Your
job as a kernel developer is very much to support the users. Not try
to make it easy for *you* at the cost of being nasty for *them*.

The kernel serves user space. That's what we do.

                     Linus
