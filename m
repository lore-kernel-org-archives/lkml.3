Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3ARPNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:13:38 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33129 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3ARPNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:13:36 -0500
MIME-Version: 1.0
In-Reply-To: <1357630357-7309-1-git-send-email-ldewangan@nvidia.com>
References: <1357630357-7309-1-git-send-email-ldewangan@nvidia.com>
Date: Fri, 18 Jan 2013 16:13:36 +0100
Message-ID: <CACRpkdbw-=ut2-4_aM3QeY48P+pExnc2Y85hihMvuFR2f=LXUg@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: tegra: add support for rcv-sel and drive type
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: praithatha@nvidia.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 8:32 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

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
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Patch applied, thanks!

Yours,
Linus Walleij
