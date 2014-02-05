Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaBECBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 21:01:22 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43292 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753089AbaBECBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 21:01:20 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/6eVtbgpv5uEM1dKLgno82qvMmKv63L8Y=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7D8E151DA18
Date: Tue, 4 Feb 2014 21:00:48 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-msm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv2 2/2] arm: Get rid of meminfo
Message-ID: <20140205020048.GL8533@titan.lakedaemon.net>
References: <1391558551-31395-1-git-send-email-lauraa@codeaurora.org>
 <1391558551-31395-3-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391558551-31395-3-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 04:02:31PM -0800, Laura Abbott wrote:
> memblock is now fully integrated into the kernel and is the prefered
> method for tracking memory. Rather than reinvent the wheel with
> meminfo, migrate to using memblock directly instead of meminfo as
> an intermediate.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
...
>  arch/arm/mach-orion5x/common.c           |    3 +-
>  arch/arm/mach-orion5x/common.h           |    3 +-
...

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
