Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaE2TBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:01:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58662 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaE2TBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:01:10 -0400
Message-ID: <538783F2.9020901@wwwdotorg.org>
Date: Thu, 29 May 2014 13:01:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/5] ARM: tegra: move fuse exports to tegra-soc.h
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com> <1401281677-32110-3-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1401281677-32110-3-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 06:54 AM, Peter De Schrijver wrote:
> All fuse related functionality will move to a driver in the following patches.
> To prepare for this, export all the required functionality in a global header
> file and move all users of fuse.h to tegra-soc.h. While we're at it, remove
> tegra_bct_strapping, as its only user was removed in Commit a7cbe92cef27
> ("ARM: tegra: remove tegra EMC scaling driver").

> diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h

> @@ -33,4 +54,8 @@ static inline int tegra_apb_writel_using_dma(u32 value, unsigned long offset)
>  	return -EINVAL;
>  }
>  #endif
> +
> +#endif /* __ASSEMBLY__ */
> +
> +
>  #endif /* __LINUX_TEGRA_SOC_H_ */

Nit: 2 blank lines there. I'll try and remember to fix that up when I
apply this, if nothing requires a repost.
