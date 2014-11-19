Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaKSLgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:36:15 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45728 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaKSLgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:36:13 -0500
MIME-Version: 1.0
X-Originating-IP: [95.23.100.213]
In-Reply-To: <000101cffe30$155793a0$4006bae0$%han@samsung.com>
References: <1414675442-3471-1-git-send-email-gautam.vivek@samsung.com>
	<1414675442-3471-2-git-send-email-gautam.vivek@samsung.com>
	<000101cffe30$155793a0$4006bae0$%han@samsung.com>
Date: Wed, 19 Nov 2014 12:36:11 +0100
Message-ID: <CABxcv=mams-iVBvACLZ-=Ozcs3KcHSEvxAsRSSV-eKaSnrcXSA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] arm: dts: Exynos5: Use pmu_system_controller
 phandle for dp phy
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sean Paul <seanpaul@google.com>, Ajay Kumar <ajaykumar.rs@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Kukjin to cc list]

Hello Vivek,

On Wed, Nov 12, 2014 at 5:21 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Thursday, October 30, 2014 10:24 PM, Vivek Gautam wrote:
>>
>> DP PHY now require pmu-system-controller to handle PMU register
>> to control PHY's power isolation. Adding the same to dp-phy
>> node.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
>

Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Kukjin,

This patch is -rc material and is needed to have display working in
3.18 again since commit a5ec598 ("phy: exynos-dp-video: Use syscon
support to control pmu register") landed in 3.18 and broke the Exynos
Display Port PHY:

exynos-dp-video-phy 10040728.video-phy: Failed to lookup PMU regmap

Best regards,
Javier
