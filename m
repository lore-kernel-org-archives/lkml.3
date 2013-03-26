Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772Ab3CZJ34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:29:56 -0400
Received: from linux-sh.org ([111.68.239.195]:47832 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132Ab3CZJ3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:29:55 -0400
Date: Tue, 26 Mar 2013 18:29:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 6/9] sh: cpufreq:  move cpufreq driver to drivers/cpufreq
Message-ID: <20130326092932.GA23796@linux-sh.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
 <ce8e1eec94acecba053f9c2e2b5caa48ce989777.1364229828.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce8e1eec94acecba053f9c2e2b5caa48ce989777.1364229828.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 10:24:42PM +0530, Viresh Kumar wrote:
> This patch moves cpufreq driver of SUPERH architecture to drivers/cpufreq.
> 
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: linux-sh@vger.kernel.org
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Looks ok to me.

Acked-by: Paul Mundt <lethal@linux-sh.org>
