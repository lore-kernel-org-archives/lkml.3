Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab3CYQtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:49:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54439 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086Ab3CYQtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:49:49 -0400
Message-ID: <51508029.6050801@wwwdotorg.org>
Date: Mon, 25 Mar 2013 10:49:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 0/9] ARM: CPUFreq: Move drivers arch/arm/ -> drivers/cpufreq
References: <cover.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 04:11 AM, Viresh Kumar wrote:
> Hi,
> 
> This patchset tries to move all CPUFreq drivers for ARM platforms from arch/arm
> to drivers/cpufreq directory.
> 
> This series is dependent (rebased of) on following patches:
> 
> http://www.spinics.net/lists/arm-kernel/msg232540.html
> https://lkml.org/lkml/2013/3/24/151
> 
> I want this series to go through Rafael's tree due to dependencies and so want
> Ack's by respective maintainers.

Patches 1 and 2,

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

On Tegra.
