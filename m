Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaG0Ggx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 02:36:53 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64989 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaG0Ggv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 02:36:51 -0400
Message-ID: <1406443008.5115.117.camel@marge.simpson.net>
Subject: Re: Bug on Kernel 3.16 r6: Sound and Buffering in Clementine with
 Files are Transferring to Music Directory
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 27 Jul 2014 08:36:48 +0200
In-Reply-To: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
References: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-26 at 23:41 -0400, Nick Krause wrote: 
> Hey Guys,
> I seem to be hitting my first kernel bug in the kernel stated in my
> subject line.
> When I transfer a lot of music for a brtfs external hard drive I have the music
> in clementine I am listening to is stopped for a few seconds and then continues.

The thing to do now is to collect solid data for a proper bug report.
How to reproduce etc.  See REPORTING-BUGS.

For a guy interested in kernel hacking, this is the perfect opportunity
to sink your teeth into a bug that you can reproduce on your box.

If you go there...

You could use perf sched record/lat and/or ftrace to trace/identify the
event, analyze what's going on in the kernel while the bad thing is
happening.  If you manage to get the root cause properly nailed down,
you will have dug out highly useful information.

Um, don't be surprised and appalled if you find that you're not up to
fixing this.  A more realistic goal is to capture some high quality
information, and learn how to use the tools to _chase_ bugs.  Once you
get a firm grip on a bug, you can always holler "Help, it's got me!" if
it's a serious bug.

-Mike

