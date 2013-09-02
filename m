Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab3IBWXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 18:23:20 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:60611 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759092Ab3IBWXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 18:23:19 -0400
Message-ID: <1378161032.32763.341.camel@haakon3.risingtidesystems.com>
Subject: Re: Linux 3.11
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 02 Sep 2013 15:30:32 -0700
In-Reply-To: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
References: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 14:10 -0700, Linus Torvalds wrote:
> As some people noticed, I got distracted ("Ooh, look, a squirrel..")
> and never wrote an announcement for -rc7. My bad. But it wasn't
> actually all that interesting a release apart from the date, and it
> had a silly compile error in ohci-pci if you hadn't enabled
> CONFIG_PM_RUNTIME, so we'll just forget -rc7 ever happened, ok?
> Instead, go and get the real 3.11 release, which is out there, all
> shiny and ready to be compiled and loved.
> 
> Since rc7 (ok, I lied, it happened) there's been just small fixes.
> Most of them came in from the networking tree, but there's some all
> over: some random filesystem fixes, a couple of sound fixes, a
> /proc/timer_list fix, things like that. Nothing really stands out
> (unless you happened to use the new soft-dirty code, that had a buglet
> that could really hurt), but let's hope we don't have some silly
> configuration that doesn't even compile this time around.
> 
> Shortlog appended.
> 

Hi Linus,

Unfortunately, this doesn't include the remaining target fixes for
v3.11:

Re: [GIT PULL -v2] target fixes for v3.11
http://marc.info/?l=linux-kernel&m=137799048226191&w=2

Is there a reason why these did not get PULLed..?

Thanks,

--nab

