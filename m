Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaHYLtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:49:36 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46074 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbaHYLta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:49:30 -0400
Message-ID: <53FB22C3.4030000@collabora.co.uk>
Date: Mon, 25 Aug 2014 13:49:23 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        afaerber@suse.de, Ajay Kumar <ajaykumar.rs@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ARM: exynos_defconfig: Enable options for display
 panel support
References: <1408956336-17376-1-git-send-email-javier.martinez@collabora.co.uk> <5825205.70RuHaSG5p@amdc1032>
In-Reply-To: <5825205.70RuHaSG5p@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bartlomiej,

On 08/25/2014 01:43 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Monday, August 25, 2014 10:45:36 AM Javier Martinez Canillas wrote:
>> Many Exynos devices have a display panel. Most of them just have
>> a simple panel while others have more complex configurations that
>> requires an embedded DisplayPort (eDP) to LVDS bridges.
>> 
>> This patch enables the following features to be built in the kernel
>> image to suport both setups:
>> 
>> - Direct Rendering Manager (DRM)
>> - DRM bridge registration and lookup framework
>> - Parade ps8622/ps8625 eDP/LVDS bridge
>> - NXP ptn3460 eDP/LVDS bridge
>> - Exynos Fully Interactive Mobile Display controller (FIMD)
>> - Panel registration and lookup framework
>> - Simple panels
>> - Backlight & LCD device support
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Tested-by: Kevin Hilman <khilman@linaro.org>
> 
> Could you please also do corresponding update to multi_v7_defconfig?
> 

Sure, I'll do once the PTN3460 and PS8622 bridge drivers get merged since
this patch depends on those and I would prefer to not have so many
in-flight patches with dependencies.

I just posted this patch before these two drivers landed because I noticed
that many people were wasting time figuring out the correct set of options
in order to have display working.

> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
>> ---

Best regards,
Javier

