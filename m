Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaGUKhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:37:07 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:29768 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754243AbaGUKhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:37:05 -0400
Date: Mon, 21 Jul 2014 11:36:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 3/4] ARM64: add IPI tracepoints
Message-ID: <20140721103643.GC12817@arm.com>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org>
 <1405660735-13408-4-git-send-email-nicolas.pitre@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405660735-13408-4-git-send-email-nicolas.pitre@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 06:18:54AM +0100, Nicolas Pitre wrote:
> The strings used to list IPIs in /proc/interrupts are reused for tracing
> purposes.
> 
> While at it, the code is slightly cleaned up so the ipi_types array
> indices are no longer offset by IPI_RESCHEDULE whose value is 0 anyway.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
