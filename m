Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaJPSEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 14:04:07 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:46137 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaJPSEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 14:04:05 -0400
Date: Thu, 16 Oct 2014 21:03:55 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        viresh.kumar@linaro.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org
Subject: Re: [PATCH 6/6] cpufreq: Loongson1: Add cpufreq driver for
 Loongson1B (UPDATED)
Message-ID: <20141016180355.GA14194@drone.musicnaut.iki.fi>
References: <1413357812-16895-1-git-send-email-keguang.zhang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413357812-16895-1-git-send-email-keguang.zhang@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 15, 2014 at 03:23:32PM +0800, Kelvin Cheung wrote:
> This patch adds cpufreq driver for Loongson1B which
> is capable of changing the CPU frequency dynamically.
> 
> Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>

[...]

>  obj-$(CONFIG_LOONGSON2_CPUFREQ)		+= loongson2_cpufreq.o
> +obj-$(CONFIG_LOONGSON1_CPUFREQ)		+= ls1x-cpufreq.o

Why it's called "ls1x-cpufreq" instead of "loongson1_cpufreq"?

A.
