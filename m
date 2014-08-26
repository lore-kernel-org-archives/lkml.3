Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaHZRbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:31:43 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61164 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaHZRbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:31:40 -0400
Date: Tue, 26 Aug 2014 10:31:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.17-rc2
Message-ID: <20140826173135.GA21364@roeck-us.net>
References: <CA+55aFz+3JzdB+sZgOFfzd9zczL=borNgLwZykx=_tOMD6n4qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz+3JzdB+sZgOFfzd9zczL=borNgLwZykx=_tOMD6n4qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 04:02:25PM -0700, Linus Torvalds wrote:
> So I deviated from my normal Sunday schedule partly because there
> wasn't much there (I blame the KS and LinuxCon), but partly due to
> sentimental reasons: Aug 25 is the anniversary of the original Linux
> announcement ("Hello everybody out there using minix"), so it's just a
> good day for release announcements.
> 
> Anyway, for being an rc2 it's pretty small, and I can always hope that
> things stay that way. It's about 60% drivers (drm, networking, hid,
> sound, PCI), with 15% filesystem updates (cifs, isofs, nfs), 10%
> architectures (mips, arm, some minor x86 stuff) and the rest is "misc"
> (kernel, networking, documentation).
> 
> All over the place, in other words, and nothing in particular stands out.
> 
> Please do give it a good testing,
> 
Sanity tests look pretty good.

Build results:
	total: 133 pass: 132 fail: 1
Failed builds:
	unicore32:defconfig

qemu tests all passed.

A patch for the unicore32 build failure is pending with the maintainer.

Guenter
