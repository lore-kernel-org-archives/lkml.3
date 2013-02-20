Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935267Ab3BTTWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:22:46 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:51153 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934775Ab3BTTWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:22:44 -0500
MIME-Version: 1.0
In-Reply-To: <20130220175015.GA14541@gmail.com>
References: <1361373550-4011-1-git-send-email-clark.williams@gmail.com>
	<1361373550-4011-2-git-send-email-clark.williams@gmail.com>
	<CA+8MBb+-Btdiga9omw0g_jU2eH5DwHDmNC5n1qqh9tgFjtXN7A@mail.gmail.com>
	<20130220175015.GA14541@gmail.com>
Date: Wed, 20 Feb 2013 11:17:39 -0800
Message-ID: <CA+8MBb+ObhG4g4kcZ+JoygHJWENO+oKu61WgB_O3+D4mxHUt6A@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: move RR_TIMESLICE from sysctl.h to rt.h
From: Tony Luck <tony.luck@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <clark.williams@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 9:50 AM, Ingo Molnar <mingo@kernel.org> wrote:
> Hm, didn't it get fixed via the commit below?

Together with moving RR_TIMESLICE to rt.h ... ia64 is good. But I
see commit 77852fea6e24 in the tree I built and still see the
RR_TIMESLICE errors.

I don't see the MAX_PRIO half of the problem - so it did help a bit.

-Tony
