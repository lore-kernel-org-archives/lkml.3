Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaCGTfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:35:18 -0500
Received: from smtp.math.uni-bielefeld.de ([129.70.45.10]:42141 "EHLO
	smtp.math.uni-bielefeld.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbaCGTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:35:13 -0500
Message-ID: <531A1F6E.9010303@math.uni-bielefeld.de>
Date: Fri, 07 Mar 2014 20:35:10 +0100
From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
CC: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, stern@rowland.harvard.edu, sander@humilis.net
Subject: Re: [PATCH v10 3/4] phy: Add new Exynos USB 2.0 PHY driver
References: <1394104609-28242-1-git-send-email-k.debski@samsung.com> <1394104609-28242-4-git-send-email-k.debski@samsung.com>
In-Reply-To: <1394104609-28242-4-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamil Debski wrote:
> Add a new driver for the Exynos USB 2.0 PHY. The new driver uses the generic
> PHY framework. The driver includes support for the Exynos 4x10 and 4x12
> SoC families.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  .../devicetree/bindings/phy/samsung-phy.txt        |   53 ++++
>  Documentation/phy/samsung-usb2.txt                 |  135 ++++++++
>  drivers/phy/Kconfig                                |   29 ++
>  drivers/phy/Makefile                               |    3 +
>  drivers/phy/phy-exynos4210-usb2.c                  |  261 ++++++++++++++++
>  drivers/phy/phy-exynos4x12-usb2.c                  |  328 ++++++++++++++++++++
>  drivers/phy/phy-samsung-usb2.c                     |  222 +++++++++++++
>  drivers/phy/phy-samsung-usb2.h                     |   66 ++++
>  8 files changed, 1097 insertions(+)
>  create mode 100644 Documentation/phy/samsung-usb2.txt
>  create mode 100644 drivers/phy/phy-exynos4210-usb2.c
>  create mode 100644 drivers/phy/phy-exynos4x12-usb2.c
>  create mode 100644 drivers/phy/phy-samsung-usb2.c
>  create mode 100644 drivers/phy/phy-samsung-usb2.h
>
Tested-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

USB PHY was tested on an ODROID-X2 (Exynos4412 SoC) with patches from
Kamil's previous patchset to enable the usage of the new PHY in EHCI and
OCHI.

With best wishes,
Tobias

