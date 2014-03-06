Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaCFTli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:41:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaCFTlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:41:37 -0500
Message-ID: <5318CEFB.9040606@redhat.com>
Date: Thu, 06 Mar 2014 14:39:39 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 5/6] sched: Remove needless round trip nsecs <-> tick
 conversion of steal time
References: <1394128601-26034-1-git-send-email-fweisbec@gmail.com> <1394128601-26034-6-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1394128601-26034-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 12:56 PM, Frederic Weisbecker wrote:
> When update_rq_clock_task() accounts the pending steal time for a task,
> it converts the steal delta from nsecs to tick then from tick to nsecs.
>
> There is no apparent good reason for doing that though because both
> the task clock and the prev steal delta are u64 and store values
> in nsecs.
>
> So lets remove the needless conversion.
>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>

