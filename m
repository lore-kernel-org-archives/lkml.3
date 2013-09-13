Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3IMTU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:20:27 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:62463 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3IMTU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:20:26 -0400
Message-ID: <52336576.1060908@linaro.org>
Date: Fri, 13 Sep 2013 12:20:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] Introduce timekeeper latch synchronization
References: <20130913025253.GA17218@Krystal> <20130913153020.GA24383@Krystal>
In-Reply-To: <20130913153020.GA24383@Krystal>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 08:30 AM, Mathieu Desnoyers wrote:
> By the way, if there are some standard test-bench for timekeeping, I'd
> be very interested to hear about them.
I've got a git repo of tests that I use for basic sanity checks here:
    https://github.com/johnstultz-work/timetests.git

thanks
-john

