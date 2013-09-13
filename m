Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab3IMOTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:19:06 -0400
Received: from ra.se.axis.com ([195.60.68.13]:46581 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab3IMOTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:19:04 -0400
Date: Fri, 13 Sep 2013 16:19:00 +0200
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
Subject: Re: [PATCH 061/228] cpufreq: cris: Use generic cpufreq routines
Message-ID: <20130913141900.GE32443@axis.com>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
 <d5f36a652c8fed4bb90bb711f520c964131a0d61.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5f36a652c8fed4bb90bb711f520c964131a0d61.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 03:00:07PM +0200, Viresh Kumar wrote:
> Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
> and .attr. So its better if we have generic routines for them which can be used
> by cpufreq drivers then.
> 
> This patch uses these generic routines for this driver.

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: Mikael Starvik <starvik@axis.com>
> Cc: linux-cris-kernel@axis.com
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
