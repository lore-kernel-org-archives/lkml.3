Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaFEPJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:09:55 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:60574 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaFEPJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:09:53 -0400
Date: Thu, 5 Jun 2014 16:09:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Subject: Re: [RESEND 0/4] phy: Introduce support for MiPHY365x
Message-ID: <20140605150947.GG24240@lee--X1>
References: <1400766819-22286-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400766819-22286-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Kishon,
> 
> As requested, please find the patches to be applied to your v3.16
> pull-request.

I guess this is not going to make v3.16 now. :(

Kishon can you make sure you queue for v3.17 ASAP please?

> Kind regards,
> Lee
> 
>  Documentation/devicetree/bindings/phy/phy-miphy365x.txt |  62 +++++++++++
>  arch/arm/boot/dts/stih416-b2020-revE.dts                |   6 +-
>  arch/arm/boot/dts/stih416-b2020.dts                     |   6 ++
>  arch/arm/boot/dts/stih416.dtsi                          |  14 +++
>  drivers/phy/Kconfig                                     |  10 ++
>  drivers/phy/Makefile                                    |   1 +
>  drivers/phy/phy-miphy365x.c                             | 630 ++++++++++++++++++++++
>  include/dt-bindings/phy/phy-miphy365x.h                 |  25 +++++
>  8 files changed, 753 insertions(+), 1 deletion(-)
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
