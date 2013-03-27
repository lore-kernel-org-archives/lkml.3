Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3C0KSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:18:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40363 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab3C0KS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:18:28 -0400
Message-ID: <5152C755.7010404@ti.com>
Date: Wed, 27 Mar 2013 15:47:57 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <arvind.chauhan@arm.com>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-kernel@lists.linaro.org>, <arnd.bergmann@linaro.org>,
        <linux@arm.linux.org.uk>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 3/9] cpufreq: davinci: move cpufreq driver to drivers/cpufreq
References: <cover.1364205812.git.viresh.kumar@linaro.org> <ef225dbf63b1d834761773384d3f70cb4ac7b611.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <ef225dbf63b1d834761773384d3f70cb4ac7b611.1364205812.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On 3/25/2013 3:41 PM, Viresh Kumar wrote:
> This patch moves cpufreq driver of ARM based davinci platform to
> drivers/cpufreq.
> 
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: davinci-linux-open-source@linux.davincidsp.com
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

I am unable to apply this patch for testing. Looks like this could be
because of:

Content-Type: text/plain; charset="WINDOWS-1252"

Can you get rid of that charset="WINDOWS-1252"?

Thanks,
Sekhar
