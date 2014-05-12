Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbaELQlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:41:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56662 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbaELQle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:41:34 -0400
Message-ID: <5370F9BB.9040608@wwwdotorg.org>
Date: Mon, 12 May 2014 10:41:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 2/2] ARM: tegra: add device tree for SHIELD
References: <1399883209-31169-1-git-send-email-acourbot@nvidia.com> <1399883209-31169-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1399883209-31169-3-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 02:26 AM, Alexandre Courbot wrote:
> NVIDIA SHIELD is a portable Android console embedded a Tegra 4 SoC with
> 2GB RAM and a 720p panel.
> 
> The following hardware is enabled by this device tree: UART, eMMC, USB
> (needs external power), PMIC, backlight, joystick, SD card, GPIO keys.
> 
> DSI panel, HDMI output, charger, self-powered USB, audio, wifi bluetooth
> are not supported yet but might be by future patches (likely in that
> order).
> 
> Touch panel and sensors will probably never be supported.
> 
> Initrd addresses are hardcoded to match the static values used by the
> bootloader, since it won't add them for us. All the same, a kernel
> command-line is provided to replace the one passed by the
> bootloader which is filled with garbage.
> 
> NVIDIA SHIELD is typically booted with an appended DTB to avoid
> modifications made by the bootloader.

I've applied this one patch to Tegra's for-3.16/dt branch.
