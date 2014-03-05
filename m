Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbaCEQFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:05:03 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:49102 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaCEQE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:04:57 -0500
Message-ID: <53174B19.9020009@gmail.com>
Date: Wed, 05 Mar 2014 17:04:41 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
CC: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, tjakobi@math.uni-bielefeld.de,
        stern@rowland.harvard.edu, sander@humilis.net
Subject: Re: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
References: <1394033288-5551-1-git-send-email-k.debski@samsung.com> <1394033288-5551-4-git-send-email-k.debski@samsung.com>
In-Reply-To: <1394033288-5551-4-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.03.2014 16:28, Kamil Debski wrote:
> Add a new driver for the Exynos USB 2.0 PHY. The new driver uses the generic
> PHY framework. The driver includes support for the Exynos 4x10 and 4x12
> SoC families.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>   .../devicetree/bindings/phy/samsung-phy.txt        |   53 ++++
>   Documentation/phy/samsung-usb2.txt                 |  134 ++++++++
>   drivers/phy/Kconfig                                |   29 ++
>   drivers/phy/Makefile                               |    3 +
>   drivers/phy/phy-exynos4210-usb2.c                  |  261 ++++++++++++++++
>   drivers/phy/phy-exynos4x12-usb2.c                  |  328 ++++++++++++++++++++
>   drivers/phy/phy-samsung-usb2.c                     |  222 +++++++++++++
>   drivers/phy/phy-samsung-usb2.h                     |   66 ++++
>   8 files changed, 1096 insertions(+)
>   create mode 100644 Documentation/phy/samsung-usb2.txt
>   create mode 100644 drivers/phy/phy-exynos4210-usb2.c
>   create mode 100644 drivers/phy/phy-exynos4x12-usb2.c
>   create mode 100644 drivers/phy/phy-samsung-usb2.c
>   create mode 100644 drivers/phy/phy-samsung-usb2.h

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
