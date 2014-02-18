Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaBRUGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:06:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53853 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaBRUGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:06:03 -0500
Message-ID: <5303BD27.4000905@wwwdotorg.org>
Date: Tue, 18 Feb 2014 13:05:59 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net,
        swarren@nvidia.com
CC: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: remove sysfs link when a cpu != policy->cpu,
 is removed
References: <324f43fc664f51eec355b08b6c2d4cedd2140b4c.1392628861.git.viresh.kumar@linaro.org>
In-Reply-To: <324f43fc664f51eec355b08b6c2d4cedd2140b4c.1392628861.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 02:22 AM, Viresh Kumar wrote:
> Earlier patch tried to do this but missed this piece of code to fix.
> 
> 42f921a cpufreq: remove sysfs files for CPUs which failed to come back after
> resume
> 
> Currently we are getting this on suspend/resume:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 877 at fs/sysfs/dir.c:52 sysfs_warn_dup+0x68/0x84()
> sysfs: cannot create duplicate filename '/devices/system/cpu/cpu1/cpufreq'
...
> Fix this by removing sysfs link for cpufreq directory when cpu removed isn't
> policy->cpu.

Tested-by: Stephen Warren <swarren@nvidia.com>
