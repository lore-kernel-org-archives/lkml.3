Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3JRPq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:46:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41402 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab3JRPq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:46:56 -0400
Date: Fri, 18 Oct 2013 16:46:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 Resend 29/34] cpufreq: sa11x0: Convert to light
	weight ->target_index() routine
Message-ID: <20131018154644.GC25034@n2100.arm.linux.org.uk>
References: <cover.1382104514.git.viresh.kumar@linaro.org> <fb85256f34e1a61c6c2c37c3e6fa8b1398bad683.1382104515.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb85256f34e1a61c6c2c37c3e6fa8b1398bad683.1382104515.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 07:29:52PM +0530, Viresh Kumar wrote:
> This patch converts existing .target() to newly defined light weight
> .target_index() routine for this driver.
> 
> CPUFreq core will call cpufreq_frequency_table_target() before calling this
> routine and will pass index to it.
> 
> Some existing routines are no more required and so are removed now.
> 
> Cc: Russell King <linux@arm.linux.org.uk>

I think I acked this patch.  Please ensure that my ack appears on all
that I did ack, thanks.
