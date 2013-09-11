Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3IKRHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:07:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7807 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab3IKRHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:07:52 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=owWOOl27trcA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Px2ojtpeDmIA:10 a=KKAkSRfTAAAA:8 a=_9PKuV2NLYsWSrV4chsA:9 a=CjuIK1q_8ugA:10 a=WwgC8nHKvroA:10 a=GDabatD6gA0A:10 a=YsEnT1LiCnMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 13:07:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] timekeeping: introduce timekeeping_is_busy()
Message-ID: <20130911130750.6a60d30f@gandalf.local.home>
In-Reply-To: <52309D13.3020305@linaro.org>
References: <20130911150853.GA19800@Krystal>
	<52309D13.3020305@linaro.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 09:40:51 -0700
John Stultz <john.stultz@linaro.org> wrote:

> (and it avoids me forgetting to set the owner in some future change,
> further mucking things up :).

Wow, I had to read that twice to see what you really wrote. I was
thinking "damn, John is getting vulgar!" ;-)

-- Steve 

