Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaCGTez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:34:55 -0500
Received: from smtp.math.uni-bielefeld.de ([129.70.45.10]:42133 "EHLO
	smtp.math.uni-bielefeld.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbaCGTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:34:53 -0500
Message-ID: <531A1F5A.7060504@math.uni-bielefeld.de>
Date: Fri, 07 Mar 2014 20:34:50 +0100
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
Subject: Re: [PATCH v10 2/4] phy: core: Add devm_of_phy_get to phy-core
References: <1394104609-28242-1-git-send-email-k.debski@samsung.com> <1394104609-28242-3-git-send-email-k.debski@samsung.com>
In-Reply-To: <1394104609-28242-3-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamil Debski wrote:
> Adding devm_of_phy_get will allow to get phys by supplying a
> pointer to the struct device_node instead of struct device.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
>  include/linux/phy/phy.h |    8 ++++++++
>  2 files changed, 39 insertions(+)
Tested-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

USB PHY was tested on an ODROID-X2 (Exynos4412 SoC) with patches from
Kamil's previous patchset to enable the usage of the new PHY in EHCI and
OCHI.

With best wishes,
Tobias

