Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaKSRME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:12:04 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60038 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbaKSRMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:12:01 -0500
Message-ID: <546CCF5A.4030808@collabora.co.uk>
Date: Wed, 19 Nov 2014 18:11:54 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] ARM: exynos_defconfig: Enable LM90 driver
References: <1416412585-10809-1-git-send-email-afaerber@suse.de> <1416412585-10809-4-git-send-email-afaerber@suse.de>
In-Reply-To: <1416412585-10809-4-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

On 11/19/2014 04:56 PM, Andreas Färber wrote:
> multi_v7_defconfig has it as Y already, so build it in here, too, for
> consistency, and therefore build in HWMON as well.
> 
> Signed-off-by: Andreas Färber <afaerber@suse.de>

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier

