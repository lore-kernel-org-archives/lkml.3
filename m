Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaE2TO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:14:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37128 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbaE2TO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:14:28 -0400
Message-ID: <53878711.9050702@wwwdotorg.org>
Date: Thu, 29 May 2014 13:14:25 -0600
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
Subject: Re: [PATCH v5 5/5] ARM: tegra: build new fuse driver in drivers/misc
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com> <1401281677-32110-6-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1401281677-32110-6-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 06:54 AM, Peter De Schrijver wrote:
> The Tegra fuse code has moved to drivers/misc/fuse/tegra. Enable the
> building of that code, and disable the building of the old fuse code in
> arch/arm/mach-tegra/.

> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 7eb4b69..994d02d 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -55,3 +55,5 @@ obj-$(CONFIG_SRAM)		+= sram.o
>  obj-y				+= mic/
>  obj-$(CONFIG_GENWQE)		+= genwqe/
>  obj-$(CONFIG_ECHO)		+= echo/
> +obj-y				+= fuse/
> +

This adds an empty blank line to the end of the file.

