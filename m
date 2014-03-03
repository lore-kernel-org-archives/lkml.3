Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaCCDxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:53:19 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5130 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaCCDxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:53:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 02 Mar 2014 19:49:11 -0800
Message-ID: <5313FCA9.9020809@nvidia.com>
Date: Mon, 3 Mar 2014 12:53:13 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH] ARM: tegra: add device tree for SHIELD
References: <1393818596-26775-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1393818596-26775-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 12:49 PM, Alexandre Courbot wrote:
> Add a device tree for NVIDIA SHIELD. The set of enabled features is
> still minimal with no display option and USB requiring external power.
>
> A default kernel command-line as well as initrd addresses are hardcoded
> to match the static values the bootloader is known to use. This allows
> booting from an appended DTB without having to alter it at boot time,
> since the bootloader has no Device Tree support.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---

Forgot to specify this is a v2, apologies for the inconvenience.

Changes since v1:
- Comment on the memory range
- Removed nodes for currently unsupported hardware (i.e. wifi)

