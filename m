Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3JHCvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:51:47 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:63402 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3JHCvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <20131008021452.GA6456@localhost>
References: <20131006082340.GA24568@localhost>
	<CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
	<20131007021118.GA27927@localhost>
	<20131007051038.GA9764@localhost>
	<CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
	<20131007083505.GA22585@localhost>
	<CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
	<CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
	<20131008020918.GA1220@localhost>
	<20131008021452.GA6456@localhost>
Date: Mon, 7 Oct 2013 19:51:37 -0700
X-Google-Sender-Auth: eto4HSbwSWygf_I9SGurPRDPY-A
Message-ID: <CA+55aFwrovZf-LYa=_SyMNvqQkTfxREm0YuzDk8wJy+Krs0xzw@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 7:14 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> I got a call trace containing parport_pc_probe_port() (is it the
> culprit?) after recompiling kernel with
>
> CONFIG_DEBUG_OBJECTS_TIMERS=y
>
> and booting with "ignore_loglevel". Here is the log for two kernel boots.

Ok, so it's definitely parport_pc. I don't see what it would do wrong, though.

               Linus
