Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbaEOSpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:45:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44881 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbaEOSo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:44:58 -0400
Message-ID: <53750B27.4020708@wwwdotorg.org>
Date: Thu, 15 May 2014 12:44:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net,
        swarren@nvidia.com
CC: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com
Subject: Re: [PATCH] cpufreq: Tegra: drop wrapper around tegra_update_cpu_speed()
References: <a38df05b91198f393b1c4b78f39110c6bece3627.1400133049.git.viresh.kumar@linaro.org>
In-Reply-To: <a38df05b91198f393b1c4b78f39110c6bece3627.1400133049.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 11:51 PM, Viresh Kumar wrote:
> Tegra has implemented an unnecessary wrapper over tegra_update_cpu_speed(), i.e.
> tegra_target(), which wasn't doing anything apart of calling
> tegra_update_cpu_speed(). Get rid of that and use tegra_target() directly.

I think it used to do something until some refactoring happened? Anyway,

Acked-by: Stephen Warren <swarren@nvidia.com>

