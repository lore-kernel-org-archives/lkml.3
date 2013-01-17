Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab3AQIaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:30:18 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:53591 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236Ab3AQIaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:30:16 -0500
MIME-Version: 1.0
In-Reply-To: <1357387375-25919-1-git-send-email-ldewangan@nvidia.com>
References: <1357387375-25919-1-git-send-email-ldewangan@nvidia.com>
Date: Thu, 17 Jan 2013 09:30:15 +0100
Message-ID: <CACRpkdYe0MPC=jiOgzd0zRkiAFas21O80MiR8dp9UdmwptDfmw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: tegra: add support for rcv-sel and drive type
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: praithatha@nvidia.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 5, 2013 at 1:02 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> From: Pritesh Raithatha <praithatha@nvidia.com>
>
> NVIDIA's Tegra114 added two more configuration parameter in pinmux i.e.
> rcv-sel and drive type.
>
> rcv-sel: Select between High and Normal VIL/VIH receivers.
>         RCVR_SEL=1: High VIL/VIH
>         RCVR_SEL=0: Normal VIL/VIH
>
> drv_type: Ouptput drive type:
>         33-50 ohm driver: 0x1
>         66-100ohm driver: 0x0
>
> Add support of these parameters to be configure from DTS file.
>
> Tegra20 and Tegra30 does not support this configuration and hence initialize their
> pinmux structure with reg = -1.
>
> Originally written by Pritesh Raithatha.
> Changes by ldewangan:
>         - remove drvtype_width as it is always 2.
>         - Better describe the change.
>
> Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Stephen, can you look at this patch?

Authors: you need Stephen's ACK on this.

Yours,
Linus Walleij
