Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab3IMObP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:31:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54611 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab3IMObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:31:11 -0400
Date: Fri, 13 Sep 2013 15:31:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 175/228] cpufreq: sa11x0: Convert to light weight
	->target_index() routine
Message-ID: <20130913143101.GW12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org> <84ed2fae0095e526e0665f5859d39d3ff22c7613.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84ed2fae0095e526e0665f5859d39d3ff22c7613.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 06:32:01PM +0530, Viresh Kumar wrote:
> This patch converts existing .target() to newly defined light weight
> .target_index() routine for this driver.
> 
> CPUFreq core will call cpufreq_frequency_table_target() before calling this
> routine and will pass index to it.
> 
> Some existing routines are no more required and so are removed now.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
