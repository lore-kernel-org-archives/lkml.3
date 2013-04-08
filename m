Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935587Ab3DHSXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:23:42 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42688 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935409Ab3DHSXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:23:40 -0400
Message-ID: <51630B26.1000102@samsung.com>
Date: Tue, 09 Apr 2013 03:23:34 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH] ARM: dts: fix bad merge of display timing node to exynos5250-smdk5250.dts
References: <1365439879-3398-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1365439879-3398-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/13 01:51, Doug Anderson wrote:
> The display timing node was added:
>    7ed2077 ARM: dts: Add display timing node to exynos5250-smdk5250.dts
> ...and looks OK there.  ...but it looks like we lost a "};" in the
> merge and it no longer compiles.  Fix it.
>
> Signed-off-by: Doug Anderson<dianders@chromium.org>
> ---
>   arch/arm/boot/dts/exynos5250-smdk5250.dts | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> index 4be14df..26d856b 100644
> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> @@ -239,6 +239,7 @@
>   			vback-porch =<4>;
>   			vfront-porch =<4>;
>   			vsync-len =<4>;
> +		};
>   	};
>
>   	fixed-rate-clocks {

Thanks for your pointing out. But it should be fixed with re-sorting out 
the branch.

If any problems, please let me know.

- Kukjin
