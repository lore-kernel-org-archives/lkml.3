Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaCDBYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:24:19 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8194 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaCDBYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:24:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 03 Mar 2014 17:20:07 -0800
Message-ID: <53152B3D.3090509@nvidia.com>
Date: Tue, 4 Mar 2014 10:24:13 +0900
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
References: <1393818596-26775-1-git-send-email-acourbot@nvidia.com> <5314B53B.4010107@wwwdotorg.org>
In-Reply-To: <5314B53B.4010107@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 02:00 AM, Stephen Warren wrote:
> On 03/02/2014 08:49 PM, Alexandre Courbot wrote:
>> Add a device tree for NVIDIA SHIELD. The set of enabled features is
>> still minimal with no display option and USB requiring external power.
>>
>> A default kernel command-line as well as initrd addresses are hardcoded
>> to match the static values the bootloader is known to use. This allows
>> booting from an appended DTB without having to alter it at boot time,
>> since the bootloader has no Device Tree support.
>
> This and the TN7 patch look fine. Hopefully I'll apply them soon,
> pending the ti,irq-externally-inverted discussion.

Great, thanks! That means only small hacks remain in my out-of-tree 
branch. Will make it easier to enable the remaining features (panel, 
Wifi, audio, etc.) from now on.

>
>> +	/* SD card */
>
> Oh, that's all you meant by wanting to add comments? I guess I just
> recognize SD-vs-eMMC by the bus width, but adding the comments is a good
> idea.

Haha no, I actually meant to add small descriptive comments in front of 
each pinmux group, but thinking twice it doesn't seem to bring as much 
readability as I initially thought,

Thanks,
Alex.

