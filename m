Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbaHGJSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:18:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41400 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212AbaHGJSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:18:49 -0400
Date: Thu, 7 Aug 2014 10:18:17 +0100
From: Will Deacon <will.deacon@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v2 4/5] ARM64: add IPI tracepoints
Message-ID: <20140807091817.GG13703@arm.com>
References: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
 <1406318733-26754-5-git-send-email-nicolas.pitre@linaro.org>
 <20140806155237.0a6d7d3c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806155237.0a6d7d3c@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 08:52:37PM +0100, Steven Rostedt wrote:
> Will and Russell,
> 
> Can you give me your Acked-by for this, and I can pull it through my
> tree?

Looks fine to me:

  Acked-by: Will Deacon <will.deacon@arm.com>

I'm assuming there's a dependency on other patches going via the tracing
tree, hence why you're taking this?

Cheers,

Will
