Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaCFTTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:19:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaCFTTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:19:24 -0500
Message-ID: <5318C9C8.90007@redhat.com>
Date: Thu, 06 Mar 2014 14:17:28 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/6] cputime: Default implementation of nsecs -> cputime
 conversion
References: <1394128601-26034-1-git-send-email-fweisbec@gmail.com> <1394128601-26034-3-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1394128601-26034-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 12:56 PM, Frederic Weisbecker wrote:
> The architectures that override cputime_t (s390, ppc) don't provide
> any version of nsecs_to_cputime(). Indeed this cputime_t implementation
> by backend only happens when CONFIG_VIRT_CPU_ACCOUNTING_NATIVE=y under
> which the core code doesn't make any use of nsecs_to_cputime().
>
> At least for now.
>
> We are going to make a broader use of it so lets provide a default
> version with a per usecs granularity. It should be good enough for most
> usecases.
>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>

