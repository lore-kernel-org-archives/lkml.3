Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3GaTNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:13:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42151 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3GaTNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:13:13 -0400
Message-ID: <51F961C5.7070302@wwwdotorg.org>
Date: Wed, 31 Jul 2013 13:13:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 14/15] cpufreq: Tegra: initialize .owner field with THIS_MODULE
References: <cover.1375279948.git.viresh.kumar@linaro.org> <7e832fd210488da0675b6c70fc9a3947eec7899d.1375279948.git.viresh.kumar@linaro.org>
In-Reply-To: <7e832fd210488da0675b6c70fc9a3947eec7899d.1375279948.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 08:19 AM, Viresh Kumar wrote:
> CPUFreq core does following at multiple places:
> module_{get|put}(cpufreq_driver->owner)).
> 
> This is done to make sure module doesn't get unloaded if it is currently in use.
> This will work only if the .owner field of cpufreq driver is initialized with a
> valid pointer.
> 
> This field wasn't initialized for this driver, lets initialize it with
> THIS_MODULE.

Acked-by: Stephen Warren <swarren@nvidia.com>

I assume this is all part of a series you'll take through the cpufreq tree.
