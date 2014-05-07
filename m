Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaEGXdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:33:39 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17377 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaEGXde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:33:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 07 May 2014 16:28:54 -0700
Message-ID: <536AC45F.6080608@nvidia.com>
Date: Thu, 8 May 2014 08:40:15 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: enable console framebuffer rotation
References: <1399432682-677-1-git-send-email-acourbot@nvidia.com> <536A57FA.2090608@wwwdotorg.org>
In-Reply-To: <536A57FA.2090608@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 12:57 AM, Stephen Warren wrote:
> On 05/06/2014 09:18 PM, Alexandre Courbot wrote:
>> Console rotation is needed for devices like Tegra Note 7 and NVIDIA
>> SHIELD to get the boot console in the expected orientation.
>
> I've squashed this into Tegra's for-3.16/defconfig branch.
>
> Can you please also update multi_v7_defconfig, and send that change to
> arm-soc (arm@kernel.org) to be applied. Thanks.

I omitted doing this for now because the devices that require this 
option (TN7/SHIELD) need a custom build with appended DTB and/or 
command-line anyway. Therefore they cannot use a multi-mach kernel and 
might as well be built against Tegra's defconfig. Does your remark above 
still apply in spite of this?

Thanks,
Alex.
