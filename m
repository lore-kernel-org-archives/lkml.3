Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaCFS7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:59:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaCFS7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:59:31 -0500
Message-ID: <5318C50D.2010505@redhat.com>
Date: Thu, 06 Mar 2014 13:57:17 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] cputime: Fix nsecs_to_cputime() return type cast
References: <1394128601-26034-1-git-send-email-fweisbec@gmail.com> <1394128601-26034-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1394128601-26034-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 12:56 PM, Frederic Weisbecker wrote:
> Even though nsec based cputime_t maps to u64, nsecs_to_cputime() must
> return a cputime_t value. We want to enforce this kind of cast in order
> to track down buggy manipulations of cputime_t such as direct access
> of its values under wrong assumptions on its backend type (nsecs,
> jiffies, etc...) by core code.
>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>

