Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3JMXMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 19:12:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50647 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755277Ab3JMXMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 19:12:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.12-rc5
Date: Mon, 14 Oct 2013 01:24:35 +0200
Message-ID: <8242024.cY0aX8uvy9@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CA+55aFxgsfhJd83tjz8yyC2UoAWzeM00R+1Zj8e3703jpJcX_w@mail.gmail.com>
References: <CA+55aFxgsfhJd83tjz8yyC2UoAWzeM00R+1Zj8e3703jpJcX_w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, October 13, 2013 03:52:49 PM Linus Torvalds wrote:
> Things seem to be calming down nicely, and rc5 is smaller than previous rc's.
> 
> In fact, the most excitement we had this week wasn't even a kernel
> bug, it was a compiler bug wrt "asm goto" that was found because of
> code that is pending to be merged in 3.13. But the (happily fairly
> straightforward) workaround for the bug was merged early, because we
> _do_ use asm goto, and it's unclear whether our existing use might
> already trigger the bug, just not enough to be as obviously
> noticeable.
> 
> Aside from that, most of the changes here are the usual architecture
> fixes (tile, arm, x86, s390) and drivers (gpu, hid, sound, i2c,
> watchdog). With btrfs and the perf tool updates rounding out the rest.
> And the usual random noise.
> 
> Go forth and test,

It looks like my pull request from yestarday has fallen through the cracks:

http://marc.info/?l=linux-acpi&m=138161145214296&w=2

Or is there anything wrong with it?

Rafael

