Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaGBJUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:20:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40702 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbaGBJUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:20:40 -0400
Message-ID: <53B3CEBD.2060609@ti.com>
Date: Wed, 2 Jul 2014 14:49:57 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <kernel@stlinux.com>
Subject: Re: [PATCH 0/5] phy: miphy365x: Introduce support for MiPHY365x
References: <1404133317-25953-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1404133317-25953-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 30 June 2014 06:31 PM, Lee Jones wrote:
> Hi Kishon,
> 
> This submission is the same as the last one, only each channel is
> now represented by its own sub-node.  The documentation has also

really cool.

Thanks
Kishon
> been updated accordingly.
> 
> Kind regards,
> Lee
> 
>  .../devicetree/bindings/phy/phy-miphy365x.txt      |  76 +++
>  arch/arm/boot/dts/stih416-b2020-revE.dts           |   5 +
>  arch/arm/boot/dts/stih416-b2020.dts                |   7 +
>  arch/arm/boot/dts/stih416.dtsi                     |  21 +
>  drivers/phy/Kconfig                                |  10 +
>  drivers/phy/Makefile                               |   1 +
>  drivers/phy/phy-miphy365x.c                        | 676 +++++++++++++++++++++
>  include/dt-bindings/phy/phy-miphy365x.h            |  25 +
>  8 files changed, 821 insertions(+)
> 
