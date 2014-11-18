Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaKRQCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:02:04 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43479 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaKRQCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:02:02 -0500
Message-ID: <546B6D14.3090807@vanguardiasur.com.ar>
Date: Tue, 18 Nov 2014 13:00:20 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Organization: VanguardiaSur
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: treding@nvidia.com, swarren@nvidia.com, pdeschrijver@nvidia.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] misc: Remove unused fuse/Makefile
References: <1414516354-29932-1-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1414516354-29932-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(increasing CC list)

On 10/28/2014 02:12 PM, Ezequiel Garcia wrote:
> This commit:
> 
> commit 783c8f4c84451bc444e314a71b447239c6ef6fd9
> Author: Peter De Schrijver <pdeschrijver@nvidia.com>
> Date:   Thu Jun 12 18:36:37 2014 +0300
> 
>     soc/tegra: Add efuse driver for Tegra
> 
> introduced a fuse driver in drivers/soc. While at it, an unused file
> drivers/misc/fuse/Makefile sneaked in, apparently as a left over from
> a previous series. Remove it.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> ---
>  drivers/misc/fuse/Makefile | 1 -
>  1 file changed, 1 deletion(-)
>  delete mode 100644 drivers/misc/fuse/Makefile
> 
> diff --git a/drivers/misc/fuse/Makefile b/drivers/misc/fuse/Makefile
> deleted file mode 100644
> index 0679c4f..0000000
> --- a/drivers/misc/fuse/Makefile
> +++ /dev/null
> @@ -1 +0,0 @@
> -obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
> 

-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
