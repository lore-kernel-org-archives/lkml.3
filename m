Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaFYBZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:25:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:39514 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbaFYBZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:25:27 -0400
Message-ID: <1403659426.4587.192.camel@pasglop>
Subject: Re: [PATCH v2] sched: Fix compiler warnings
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 25 Jun 2014 11:23:46 +1000
In-Reply-To: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 18:05 -0700, Guenter Roeck wrote:

 .../...

> Drop 'const' from the function declarations to fix the problem.
> 
> The fix for all three patches has to be applied together to avoid
> compilation failures for the affected architectures.
> 
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Fix problem in all affected architectures with a single patch
>     to avoid compilation errors.


