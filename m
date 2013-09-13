Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3IMS2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:28:10 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49971 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3IMS2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:28:08 -0400
Message-ID: <52335935.1020307@linaro.org>
Date: Fri, 13 Sep 2013 11:28:05 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] Introduce timekeeper latch synchronization
References: <20130913025253.GA17218@Krystal> <alpine.DEB.2.02.1309131803360.4089@ionos.tec.linutronix.de> <523345EC.8070206@efficios.com> <52334E5A.4050609@linaro.org> <20130913182020.GB32317@Krystal>
In-Reply-To: <20130913182020.GB32317@Krystal>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 11:20 AM, Mathieu Desnoyers wrote:
>
> This looks to me like interesting optimisation work that should be
> considered after the following question is answered: does the added
> update-side cost actually matter that much ?

Yea, fair enough. We can measure the cost first.

thanks
-john

