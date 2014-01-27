Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaA0Rga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:36:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33891 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaA0Rg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:36:28 -0500
Date: Mon, 27 Jan 2014 18:35:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/9] ARM: get rid of arch_cpu_idle_prepare()
Message-ID: <20140127173557.GE4941@twins.programming.kicks-ass.net>
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
 <1390802904-28399-2-git-send-email-nicolas.pitre@linaro.org>
 <52E6175F.1050401@linaro.org>
 <20140127160736.GP15937@n2100.arm.linux.org.uk>
 <52E69395.9020004@linaro.org>
 <20140127172110.GR15937@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127172110.GR15937@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 05:21:10PM +0000, Russell King - ARM Linux wrote:
> A reviewed-by tag on its own doesn't mean much, as it could mean that
> you've just glanced over the code and decided "yea, it looks okay", or
> it could mean that you've spent all day verifying that the code change
> is indeed correct.

One should use Acked-by for the 'yea, it looks okay' thing.
