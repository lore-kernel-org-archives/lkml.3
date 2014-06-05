Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaFERB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:01:28 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17665 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaFERB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:01:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Jun 2014 09:53:24 -0700
Message-ID: <5390A262.50402@nvidia.com>
Date: Thu, 5 Jun 2014 20:01:22 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 3/5] misc: fuse: Add efuse driver for Tegra
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com> <1401973754-19701-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1401973754-19701-4-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/14 16:09, Peter De Schrijver wrote:
> +       dev_info(dev,
> +               "Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
> +               tegra_revision_name[sku_info->revision],
> +               sku_info->sku_id, sku_info->cpu_process_id,
> +               sku_info->core_process_id);

sku_info->sku_id doesn't seem to get initialized anywhere - with an 
older revision of this set I see SKU: 0 in place of what the L4T kernel 
prints (SKU: 0x81).

-- 
nvpublic
