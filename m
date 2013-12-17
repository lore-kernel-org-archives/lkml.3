Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3LQSRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:17:51 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20201 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932340Ab3LQSRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:17:47 -0500
Date: Tue, 17 Dec 2013 18:17:26 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>
Subject: Re: [PATCH v4] arm64: support single-step and breakpoint handler
 hooks
Message-ID: <20131217181726.GU32118@arm.com>
References: <1386136220-15171-1-git-send-email-sandeepa.prabhu@linaro.org>
 <1386136220-15171-2-git-send-email-sandeepa.prabhu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386136220-15171-2-git-send-email-sandeepa.prabhu@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 05:50:20AM +0000, Sandeepa Prabhu wrote:
> AArch64 Single Steping and Breakpoint debug exceptions will be
> used by multiple debug framworks like kprobes & kgdb.
> 
> This patch implements the hooks for those frameworks to register
> their own handlers for handling breakpoint and single step events.
> 
> Reworked the debug exception handler in entry.S: do_dbg to route
> software breakpoint (BRK64) exception to do_debug_exception()
> 
> Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
> Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
> Acked-by: Will Deacon <will.deacon@arm.com>

Thanks. Applied.

-- 
Catalin
