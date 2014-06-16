Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaFPJ0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:26:48 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44140 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755005AbaFPJ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:26:46 -0400
Date: Mon, 16 Jun 2014 10:26:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [linux-next] arm64: ftrace: Fix comment typo
 'CONFIG_FUNCTION_GRAPH_FP_TEST'
Message-ID: <20140616092630.GA3971@arm.com>
References: <1402479861.3798.63.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402479861.3798.63.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:44:21AM +0100, Paul Bolle wrote:
> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
> index b051871f2965..aa5f9fcbf9ee 100644
> --- a/arch/arm64/kernel/entry-ftrace.S
> +++ b/arch/arm64/kernel/entry-ftrace.S
> @@ -205,7 +205,7 @@ ENDPROC(ftrace_graph_caller)
>   *
>   * Run ftrace_return_to_handler() before going back to parent.
>   * @fp is checked against the value passed by ftrace_graph_caller()
> - * only when CONFIG_FUNCTION_GRAPH_FP_TEST is enabled.
> + * only when CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST is enabled.
>   */
>  ENTRY(return_to_handler)
>  	str	x0, [sp, #-16]!

Thanks. Applied.

-- 
Catalin
