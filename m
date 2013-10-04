Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3JDFZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 01:25:44 -0400
Received: from gw.cm.dream.jp ([59.157.128.2]:51059 "EHLO vsmtp02.cm.dti.ne.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750831Ab3JDFZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 01:25:42 -0400
Date: Fri, 4 Oct 2013 14:25:17 +0900
From: takasi-y@ops.dti.ne.jp
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: SH-Linux <linux-sh@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] sh: clkfwk: Select sh-/common- clkfwk alternatively
Message-Id: <20131004142517.590a96bcb63330313ceb5298@ops.dti.ne.jp>
In-Reply-To: <1663688.MHxO4ng5PY@avalon>
References: <52410F86.4040301@renesas.com>
	<20130924131206.d57d07f5faa5cb0773fc328c@ops.dti.ne.jp>
	<1663688.MHxO4ng5PY@avalon>
X-Mailer: Sylpheed 3.4.0beta3 (GTK+ 2.24.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

> While I agree with this patch, I believe the use of the HAVE_MACH_CLKDEV 
> configuration option to select whether to compile core.o in is a bit of an 
> abuse. <snip>
Well, yes, indeed. It does not mean having include/mach/clkdev.h,
but means somewhat such like !COMMON_CLK.
# I think there is similar usage in arch/mips, though they define but not use.
# ... is an execution.

> However, as all ARCH_SHMOBILE platforms should be converted to the common 
> clock framework, this is only temporary and could be revisited later, so I'm 
> fine with keeping the patch as-is.
Sure.

Thank you for your review.
/yoshii
