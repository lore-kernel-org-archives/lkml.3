Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab3IMP0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:26:54 -0400
Received: from ra.se.axis.com ([195.60.68.13]:49600 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab3IMP0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:26:51 -0400
Date: Fri, 13 Sep 2013 17:26:49 +0200
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
Subject: Re: [PATCH 187/228] cpufreq: cris: remove calls to
 cpufreq_notify_transition()
Message-ID: <20130913152649.GI32443@axis.com>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
 <c8374403df5f41c355e2e3c33de384382e0a746a.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8374403df5f41c355e2e3c33de384382e0a746a.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 03:02:13PM +0200, Viresh Kumar wrote:
> Most of the drivers do following in their ->target_index() routines:
> 
> 	struct cpufreq_freqs freqs;
> 	freqs.old = old freq...
> 	freqs.new = new freq...
> 
> 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> 
> 	/* Change rate here */
> 
> 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> 
> This is replicated over all cpufreq drivers today and there doesn't exists a
> good enough reason why this shouldn't be moved to cpufreq core instead.
> 
> Earlier patches have added support in cpufreq core to do cpufreq notification on
> frequency change, this one removes it from this driver.
> 
> Some related minor cleanups are also done along with it.

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: Mikael Starvik <starvik@axis.com>
> Cc: linux-cris-kernel@axis.com
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
