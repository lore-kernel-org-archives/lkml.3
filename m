Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3HGRiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:38:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56696 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab3HGRio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:38:44 -0400
Message-ID: <52028620.6000608@wwwdotorg.org>
Date: Wed, 07 Aug 2013 11:38:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, swarren@nvidia.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] clk: Tegra: Add CPU0 clock driver
References: <cover.1375886595.git.viresh.kumar@linaro.org> <8d192a13cb7e088943da40689d62bc6353bd8604.1375886595.git.viresh.kumar@linaro.org>
In-Reply-To: <8d192a13cb7e088943da40689d62bc6353bd8604.1375886595.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 08:46 AM, Viresh Kumar wrote:
> This patch adds CPU0's clk driver for Tegra. It will be used by the generic
> cpufreq-cpu0 driver to get/set cpu clk.
> 
> Most of the platform specific bits are picked from tegra-cpufreq.c.

Hmmm. I'm not sure if it makes sense to represent this as a clock
object; isn't this more of a virtual construct that manages the rate of
the clock, rather than an actual clock? The actual clock already exists
as "cpu".
