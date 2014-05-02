Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaEBSUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:20:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53159 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaEBSUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:20:48 -0400
Message-ID: <5363E1FC.3080006@wwwdotorg.org>
Date: Fri, 02 May 2014 12:20:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v2] ARM: tegra: add Tegra Note 7 device tree
References: <1399017548-1638-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1399017548-1638-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 01:59 AM, Alexandre Courbot wrote:
> Tegra Note 7 is a consumer tablet embedding a Tegra 4 SoC with 1GB RAM
> and a 720p panel.
> 
> The following hardware is enabled by this device tree: UART, eMMC, USB
> (needs external power), PMIC, backlight, DSI panel, keys.
> 
> SD card, HDMI, charger, self-powered USB, audio, wifi, bluetooth are not
> yet supported but might be by future patches (likely in that order).
> 
> Touch panel, sensors & cameras will probably never be supported.
> 
> Pinctrl is not set yet, as the bootloader-provided values allow us to
> use the currently supported hardware.
> 
> Initrd addresses are hardcoded to match the static values used by the
> bootloader, since it won't add them for us. All the same, a kernel
> command-line is provided to replace the one passed by the bootloader
> which is filled with garbage.

I've applied this to Tegra's for-3.16/dt branch.
