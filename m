Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaAILqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:46:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:48328 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaAILqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:46:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,630,1384329600"; 
   d="scan'208";a="456025319"
Date: Thu, 9 Jan 2014 19:46:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 Resend] cpufreq: create cpufreq_generic_get() routine
Message-ID: <20140109114619.GA20423@localhost>
References: <d9239e0a5df99392647ff8343673342f89d09476.1389059568.git.viresh.kumar@linaro.org>
 <CAOesGMgfFVoVJpOMXWtzVWj_F4pD-L9Osyv4u6=c8RUWOoLHFw@mail.gmail.com>
 <CAKohpo=EsaBPdF3wYsa2rEdjcpPagbhPcxWw1_PA=yVLDnjRiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=EsaBPdF3wYsa2rEdjcpPagbhPcxWw1_PA=yVLDnjRiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> @Fengguang: Would it make sense to add build tests for all ARM
> defconfigs in your build system? I thought its already there :)
> That way I can always be sure that my stuff (would be helpful for
> others as well though) isn't breaking build (Atleast) for any platform.

Sure. I just added build test workers for all defconfigs from all
archs. Note that due to the large number of configs, they'll have
longer delays, but should still finish in one day.

Thanks,
Fengguang
