Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3KKNGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:06:00 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:35474 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab3KKNFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:05:55 -0500
MIME-Version: 1.0
In-Reply-To: <20131110190633.GA18073@citd.de>
References: <CALeOzZ_K0o_h4gJ4w-twL5=-0QjC1XWb=m948wXWwjndr4q_Kw@mail.gmail.com>
	<20131110190633.GA18073@citd.de>
Date: Mon, 11 Nov 2013 14:05:53 +0100
Message-ID: <CALeOzZ_TpR7UxevNZET=ZFu8qL=646pWDwebNT6FH5Jvhv4-GA@mail.gmail.com>
Subject: Re: Partially Privileged Applications
From: Shahbaz Youssefi <shabbyx@gmail.com>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 8:06 PM, Matthias Schniedermeyer <ms@citd.de> wrote:
> I don't see a way around "borders" (Papers please), otherwise you can't
> reject things you don't want, you have to check if that something that
> is to be done is allowed. For e.g. you would get around every
> permission-check, because the code you called is allowed to do
> everything.

You're right actually. Proper linking solves the issue for "good people",
but I can't think of a not-dirty way for preventing bad calls from
"bad people". I may get back here if I do find a solution.

> And your driver model sounds more like a micro-kernel
> http://en.wikipedia.org/wiki/Microkernel
> In the sense that a driver is more like a privileged process.

That is true. I understood that but I thought better not mention
microkernels, just to avoid any reaction given "the history"!
I guess I would have appreciated it if Linux was a mikrokernel
or a hybrid, given how f*ing hard it is find a bug in someone else's
kernel module that just hangs the kernel.
