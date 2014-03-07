Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaCGTee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:34:34 -0500
Received: from smtp.math.uni-bielefeld.de ([129.70.45.10]:42126 "EHLO
	smtp.math.uni-bielefeld.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbaCGTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:34:32 -0500
Message-ID: <531A1F43.4020506@math.uni-bielefeld.de>
Date: Fri, 07 Mar 2014 20:34:27 +0100
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
Subject: Re: [PATCH v10 1/4] phy: core: Add an exported of_phy_get function
References: <1394104609-28242-1-git-send-email-k.debski@samsung.com> <1394104609-28242-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1394104609-28242-2-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamil Debski wrote:
> Previously the of_phy_get function took a struct device * and
> was declared static. It was impossible to call it from
> another driver and thus it was impossible to get phy defined
> for a given node. The old function was renamed to _of_phy_get
> and was left for internal use. of_phy_get function was added
> and it was exported. The function enables to get a phy for
> a given device tree node.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/phy/phy-core.c  |   45 ++++++++++++++++++++++++++++++++++++---------
>  include/linux/phy/phy.h |    6 ++++++
>  2 files changed, 42 insertions(+), 9 deletions(-)
>
Tested-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

USB PHY was tested on an ODROID-X2 (Exynos4412 SoC) with patches from
Kamil's previous patchset to enable the usage of the new PHY in EHCI and
OCHI.

With best wishes,
Tobias

