Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaGaTUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:20:24 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41027 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaGaTUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:20:22 -0400
Message-ID: <53DA96EF.8050203@gmail.com>
Date: Thu, 31 Jul 2014 21:20:15 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Doug Anderson <dianders@chromium.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/4] ARM: dts: Fix MMC pinctrl for exynos5250-snow
References: <1406822910-6255-1-git-send-email-afaerber@suse.de> <1406822910-6255-2-git-send-email-afaerber@suse.de>
In-Reply-To: <1406822910-6255-2-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.07.2014 18:08, Andreas Färber wrote:
> The pinctrl properties should be on the device directly and not on the
> slot sub-node.
> 
> Reported-by: Doug Anderson <dianders@chromium.org>
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v3 -> v4: Unchanged
>  
>  v3: New (Doug Anderson)
>  Redundant with Jaehoon Chung's general slot@0 deprecation,
>  in case that hits the tree earlier.
> 
>  arch/arm/boot/dts/exynos5250-snow.dts | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
