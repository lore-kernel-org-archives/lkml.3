Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaHUEdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 00:33:49 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:46763 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbaHUEdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 00:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
Date: Thu, 21 Aug 2014 10:03:46 +0530
X-Google-Sender-Auth: aRqUJTAIgaFPabh2UI-YTVoYKZc
Message-ID: <CAFp+6iG+BoE5O=EBxNOGPGU3Wws26xtQzzVx1HBhQ3R0SafiMw@mail.gmail.com>
Subject: Re: [PATCH 0/5] usb: phy: samsung: remove old USB PHY code
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>, Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 7:55 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> Hi,
>
> This patch series removes the old Samsung USB PHY drivers that
> got replaced by the new ones using the generic PHY layer.
>
> Depends on:
> - next-20140813 branch of linux-next kernel
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
>
> Bartlomiej Zolnierkiewicz (5):
>   ARM: dts: remove old USB2 PHY node hook for Arndale
>   ARM: dts: remove old USB2 PHY node for Exynos5250
>   usb: phy: samsung: remove old USB 2.0 PHY driver
>   usb: phy: samsung: remove old USB 3.0 PHY driver
>   usb: phy: samsung: remove old common USB PHY code

Reviewed-by: Vivek Gautam <gautam.vivek@samsung.com>



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
