Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3EEUdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 16:33:47 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:61545 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3EEUdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 16:33:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130505110351.GA4768@gmail.com>
References: <20130505110351.GA4768@gmail.com>
Date: Sun, 5 May 2013 13:33:45 -0700
X-Google-Sender-Auth: MFKSR_dePTO9q-iqemSHvkDyJ7g
Message-ID: <CA+55aFzPHkCH7CVZ4tkaF91+=GLZAxxncTq0J9d6AKpSPqovZw@mail.gmail.com>
Subject: Re: [GIT PULL, RFC] Full dynticks, CONFIG_NO_HZ_FULL feature
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 5, 2013 at 4:03 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please consider pulling the latest timers-nohz-for-linus git tree from:

Ok, it seems to work for me, so pulled.

However, by "work for me" I mean "doesn't actually seem to make any
difference for me". Maybe I'm odd, but the most common situation is
either a fairly idle machine (in which case the old NOHZ did fine) or
a fairly over-crowded one when I'm running something sufficiently
threaded (in which case the new NOHZ_FULL doesn't do anything either).

So I really hope the "cpu has more than one running thread" case is
getting a lot of attention. Not for 3.10, but right now it seems to
still result in the same old 1kHz timer interrupts..

So I haven't actually found a real load where any of this makes a
noticeable *difference*.

                 Linus
