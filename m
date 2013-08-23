Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3HWJP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:15:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42497 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3HWJPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:15:55 -0400
Date: Fri, 23 Aug 2013 10:15:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Javi Merino <javi.merino@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if
	UP system
Message-ID: <20130823091537.GL6617@n2100.arm.linux.org.uk>
References: <20130712121023.GB27430@codeaurora.org> <51E71249.4050200@codeaurora.org> <alpine.LFD.2.03.1307171830170.14924@syhkavp.arg> <51E71C78.6080604@codeaurora.org> <alpine.LFD.2.03.1307171849180.14924@syhkavp.arg> <51E7236D.3010700@codeaurora.org> <20130822184312.GE23960@codeaurora.org> <alpine.LFD.2.03.1308221458320.14472@syhkavp.arg> <20130823043527.GG23960@codeaurora.org> <alpine.LFD.2.03.1308230049230.14472@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1308230049230.14472@syhkavp.arg>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 12:51:59AM -0400, Nicolas Pitre wrote:
> Blah.  OK then, just send it to Thomas.
> 
> Initially this code was written and committed by RMK which is why I 
> suggested you send him the fix.

It _should_, because the author of the file presumably knows how the
driver is supposed to work much better than the maintainer of the
subsystem.  So driver authors _should_ always be involved in the
handling of the patch.

Unfortunately, that rarely happens, and I've given up any hope of the
old kernel process(es) remaining where authors were responsible for the
code they wrote.  Somehow, kernel maintanence has been perversed so that
subsystem maintainers get to decide whether patches to drivers that they
don't have hardware for are to be applied irrespective of whether the
driver author has any input to it.
