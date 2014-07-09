Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaGIOxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:53:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38716 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaGIOxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:53:16 -0400
Message-ID: <53BD572C.4060406@ti.com>
Date: Wed, 9 Jul 2014 20:22:28 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <kernel@stlinux.com>
Subject: Re: [PATCH v3 0/5] phy: miphy365x: Introduce support for MiPHY365x
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wednesday 09 July 2014 05:11 PM, Lee Jones wrote:
> Hi Kishon,
> 
> This patchset is based on the two core patches you sent to the
> list which facilitate creating PHYs residing on multi-channel
> controllers.  The changes since the last submission centre
> around dynamic PHY creation based solely on what is provided via
> Device Tree, as requested.  The other review comments have also
> been addressed in this set.

This series looks good to me. Will queue it next week.

Thanks
Kishon
> 
> Kind regards,
> Lee
> 
>  .../devicetree/bindings/phy/phy-miphy365x.txt      |  76 +++
>  arch/arm/boot/dts/stih416-b2020-revE.dts           |  10 +
>  arch/arm/boot/dts/stih416-b2020.dts                |  12 +
>  arch/arm/boot/dts/stih416.dtsi                     |  22 +
>  drivers/phy/Kconfig                                |  10 +
>  drivers/phy/Makefile                               |   1 +
>  drivers/phy/phy-miphy365x.c                        | 636 +++++++++++++++++++++
>  include/dt-bindings/phy/phy-miphy365x.h            |  14 +
>  8 files changed, 781 insertions(+)
> 
