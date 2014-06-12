Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbaFLJEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:04:06 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:44459 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbaFLJEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:04:04 -0400
MIME-Version: 1.0
In-Reply-To: <1402556024.4224.2.camel@jlt4.sipsolutions.net>
References: <20140611234024.103571777@linutronix.de> <20140611234607.020125642@linutronix.de>
 <1402556024.4224.2.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 12 Jun 2014 02:03:41 -0700
X-Google-Sender-Auth: sphT6j6aC6bAHy6LMExMwK9tvlQ
Message-ID: <CAB=NE6UqxX=K2iZhHQBmMU4wTBmAmj7KbnJBktepB8+JJn0LDQ@mail.gmail.com>
Subject: Re: [patch 04/13] net: mac80211: Use ktime_get_ts()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>, cocci@systeme.lip6.fr
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 11:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-06-11 at 23:59 +0000, Thomas Gleixner wrote:
>
>> do_posix_clock_monotonic_gettime() is a leftover from the initial
>> posix timer implementation which maps to ktime_get_ts().
>
> I didn't even know we *had* such code, heh.

If we want want maintainers to police this stuff we can add an SmPL
rule for this upstream and have maintainer use 'make coccicheck
M=path/'. The way of the future. The way of the future...

  Luis
