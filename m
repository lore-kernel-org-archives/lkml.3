Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3IMPYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:24:47 -0400
Received: from ra.se.axis.com ([195.60.68.13]:49522 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab3IMPYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:24:45 -0400
Date: Fri, 13 Sep 2013 17:24:43 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 153/228] cpufreq: cris: Convert to light weight
 ->target_index() routine
Message-ID: <20130913152443.GH32443@axis.com>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
 <73fe150773b41450f222c179e4a7ea84884a119e.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73fe150773b41450f222c179e4a7ea84884a119e.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 03:01:39PM +0200, Viresh Kumar wrote:
> This patch converts existing .target() to newly defined light weight
> .target_index() routine for this driver.
> 
> CPUFreq core will call cpufreq_frequency_table_target() before calling this
> routine and will pass index to it.

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: Mikael Starvik <starvik@axis.com>
> Cc: linux-cris-kernel@axis.com
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
