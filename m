Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbaEIPYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:24:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46326 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbaEIPYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:24:46 -0400
Message-ID: <536CF33A.3020906@wwwdotorg.org>
Date: Fri, 09 May 2014 09:24:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Alex Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: enable console framebuffer rotation
References: <1399432682-677-1-git-send-email-acourbot@nvidia.com> <536A57FA.2090608@wwwdotorg.org> <536AC45F.6080608@nvidia.com> <536CE414.5030406@suse.de>
In-Reply-To: <536CE414.5030406@suse.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 08:20 AM, Andreas Färber wrote:
> Am 08.05.2014 01:40, schrieb Alex Courbot:
>> On 05/08/2014 12:57 AM, Stephen Warren wrote:
>>> On 05/06/2014 09:18 PM, Alexandre Courbot wrote:
>>>> Console rotation is needed for devices like Tegra Note 7 and NVIDIA
>>>> SHIELD to get the boot console in the expected orientation.
>>>
>>> I've squashed this into Tegra's for-3.16/defconfig branch.
>>>
>>> Can you please also update multi_v7_defconfig, and send that change to
>>> arm-soc (arm@kernel.org) to be applied. Thanks.
>>
>> I omitted doing this for now because the devices that require this
>> option (TN7/SHIELD) need a custom build with appended DTB and/or
>> command-line anyway. Therefore they cannot use a multi-mach kernel
> 
> What does appending a .dtb have to do with whether or not to use a
> multi-mach kernel? We package zImage/uImage and .dtbs separately, so
> surely the multi_v7_defconfig should be kept working with Tegra devices.
> Appending a .dtb only comes into play for preparing installation images.

That would be a reasonable argument if generic distro installers or
kernel packages were likely to support the TN7 and SHIELD. However,
given the bootloader situation there and the need for a custom kernel
anyway for APPENDED_DTB, I assume that's not the case on this particular
device?

If you do intend to support this device with SuSe installer and kernel
packages, could you give an outline of how you do so?
