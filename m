Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab3CSRy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:54:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35252 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab3CSRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:54:18 -0400
Message-ID: <5148A645.9020009@wwwdotorg.org>
Date: Tue, 19 Mar 2013 11:54:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: linux@arm.linux.org.uk, josephl@nvidia.com, pgaikwad@nvidia.com,
        ldewangan@nvidia.com, hdoyu@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: tegra114: add speedo-based process identification
References: <1363605454-24176-1-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1363605454-24176-1-git-send-email-dahuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 05:17 AM, Danny Huang wrote:
> Add speedo-based process identifictaion for Tegra114.

I have applied this to Tegra's for-3.10/soc branch, with one addition below:

> diff --git a/arch/arm/mach-tegra/tegra114_speedo.c b/arch/arm/mach-tegra/tegra114_speedo.c

> +#include <linux/kernel.h>

Here, I also added:

#include <linux/bug.h>

That's not needed in the Tegra for-next branch (which is based on
3.9-rc1), but is needed when merged into linux-next, and hence will
presumably be needed once this is submitted into 3.10.
