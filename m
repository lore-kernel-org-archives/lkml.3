Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3IKTTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:19:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34996 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab3IKTTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:19:32 -0400
Message-ID: <5230C240.8050602@wwwdotorg.org>
Date: Wed, 11 Sep 2013 13:19:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: rjw@sisk.pl, viresh.kumar@linaro.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/2] cpufreq: tegra: Remove not used header and clean
 up codes
References: <1378898355-31290-1-git-send-email-bilhuang@nvidia.com> <1378898355-31290-2-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1378898355-31290-2-git-send-email-bilhuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 05:19 AM, Bill Huang wrote:
> Remove inclustion of the not needed header files and remove the logic
> to check the CPU ID to not exceeding the maximum supported CPUs.

> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c

> - * Copyright (C) 2010 Google, Inc.
> + * Copyright (c) 2013, NVIDIA Corporation.
> + * Copyright (C) 2010-2013 Google, Inc.

This is such a trivial patch, I don't think it's appropriate to add an
NVIDIA (c) notice. It may well be appropriate in patch 2/2.

I assume that Google didn't write this patch, so why adjust that (c) notice?
