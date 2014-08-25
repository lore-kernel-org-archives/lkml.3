Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaHYLyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:54:13 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46081 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaHYLyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:54:12 -0400
Message-ID: <53FB23DF.70809@collabora.co.uk>
Date: Mon, 25 Aug 2014 13:54:07 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        Ajay Kumar <ajaykumar.rs@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ARM: exynos_defconfig: Enable options for display
 panel support
References: <1408956336-17376-1-git-send-email-javier.martinez@collabora.co.uk> <5825205.70RuHaSG5p@amdc1032> <53FB22E4.8040906@suse.de>
In-Reply-To: <53FB22E4.8040906@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

On 08/25/2014 01:49 PM, Andreas Färber wrote:
>> 
>> Could you please also do corresponding update to multi_v7_defconfig?
> 
> As was mentioned in v1 (but now below), some of these options depend on

Sorry for missing the mention about the dependencies on v2...

> patches yet to be respun and be accepted into drm, so I would consider
> this an RFC patch and suggest to wait with multi_v7.
> 

Agreed, I just sent an email to Bartlomiej saying the same.

> It could of course be split, as CONFIG_DRM_EXYNOS* and backlight parts
> are certainly okay.
>

Also agreed.

> Regards,
> Andreas

Best regards,
Javier
