Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab3AQIgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:36:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13619 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab3AQIgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:36:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 17 Jan 2013 00:36:47 -0800
Message-ID: <50F7B801.4020704@nvidia.com>
Date: Thu, 17 Jan 2013 14:06:17 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: tegra: add support for rcv-sel and drive
 type
References: <1357387375-25919-1-git-send-email-ldewangan@nvidia.com> <CACRpkdYe0MPC=jiOgzd0zRkiAFas21O80MiR8dp9UdmwptDfmw@mail.gmail.com>
In-Reply-To: <CACRpkdYe0MPC=jiOgzd0zRkiAFas21O80MiR8dp9UdmwptDfmw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2013 02:00 PM, Linus Walleij wrote:
> On Sat, Jan 5, 2013 at 1:02 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>
>> From: Pritesh Raithatha <praithatha@nvidia.com>
>>
>> NVIDIA's Tegra114 added two more configuration parameter in pinmux i.e.
>> rcv-sel and drive type.
>>
>> rcv-sel: Select between High and Normal VIL/VIH receivers.
>>          RCVR_SEL=1: High VIL/VIH
>>          RCVR_SEL=0: Normal VIL/VIH
>>
>> drv_type: Ouptput drive type:
>>          33-50 ohm driver: 0x1
>>          66-100ohm driver: 0x0
>>
>> Add support of these parameters to be configure from DTS file.
>>
>> Tegra20 and Tegra30 does not support this configuration and hence initialize their
>> pinmux structure with reg = -1.
>>
>> Originally written by Pritesh Raithatha.
>> Changes by ldewangan:
>>          - remove drvtype_width as it is always 2.
>>          - Better describe the change.
>>
>> Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Stephen, can you look at this patch?
>
> Authors: you need Stephen's ACK on this.


Stephen have already given his reviewed by on thi series and I posted V2 
version of taking care his comment.
Stephen's comment was in
Re: [PATCH 2/2] pinctrl: tegra114: add pinctrl driver for NVIDIA's 
Tegra114 SoC


Can you please review the v2 version of this series?


Thanks,
Laxman
