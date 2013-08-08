Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965307Ab3HHOTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:19:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37230 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965190Ab3HHOTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:19:30 -0400
Message-ID: <5203A8D9.6080901@ti.com>
Date: Thu, 8 Aug 2013 10:19:05 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 21/35] cpufreq: omap: use cpufreq_table_validate_and_show()
References: <cover.1375964117.git.viresh.kumar@linaro.org> <0cc200b71d5c1584c80845a1384aef1919fd779b.1375964117.git.viresh.kumar@linaro.org>
In-Reply-To: <0cc200b71d5c1584c80845a1384aef1919fd779b.1375964117.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 August 2013 09:48 AM, Viresh Kumar wrote:
> Lets use cpufreq_table_validate_and_show() instead of calling
> cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().
> 
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
