Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3CYMVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:21:08 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:48325 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3CYMVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:21:06 -0400
MIME-Version: 1.0
In-Reply-To: <1364213284.5053.4.camel@laptop>
References: <1363949499-3728-1-git-send-email-eranian@google.com>
	<CAFTL4hwGBFHyrY-thvOPe=CvrPu-CoFN8AGq-p8xWEWs8EPqgg@mail.gmail.com>
	<1364213284.5053.4.camel@laptop>
Date: Mon, 25 Mar 2013 13:21:04 +0100
Message-ID: <CAFTL4hxw0zZpKidZvUL5BfSC8j5tWEN+YDHx2=dVrAJFfgn4Cg@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] perf: use hrtimer for event multiplexing
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/25 Peter Zijlstra <peterz@infradead.org>:
> On Fri, 2013-03-22 at 14:54 +0100, Frederic Weisbecker wrote:
>> And I have to say this patch is going to be very useful for the full
>> dynticks tree. We are happy to get rid of that tick hook.
>
> I'm sorry to have to disappoint, but the tick hook is still there ;-),
> its just no longer used for counter rotation. Of course we have
> multiple uses for the tick, what did you think :-)
>

Haha!
Bah, at least some significant part of the work is pulled outside the hook :)
