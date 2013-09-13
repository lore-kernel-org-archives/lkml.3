Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3IMQJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:09:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54669 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3IMQJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:09:24 -0400
Date: Fri, 13 Sep 2013 17:09:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 083/228] cpufreq: sa11x0: Use generic cpufreq routines
Message-ID: <20130913160911.GC12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org> <773540c3d88ebdf24415774b0cfd31cb025c684c.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <773540c3d88ebdf24415774b0cfd31cb025c684c.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 06:30:29PM +0530, Viresh Kumar wrote:
> Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
> and .attr. So its better if we have generic routines for them which can be used
> by cpufreq drivers then.
> 
> This patch uses these generic routines for this driver.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
