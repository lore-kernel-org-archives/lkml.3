Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaGJNwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:52:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53920 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaGJNwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:52:06 -0400
Message-ID: <53BE9A0A.7040502@ti.com>
Date: Thu, 10 Jul 2014 19:20:02 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, <broonie@kernel.org>
CC: Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <kishon@ti.com>
Subject: Re: [PATCH v3 0/7] ARM: dts: AM43x: Add devcice tree nodes
References: <1404884193-20580-1-git-send-email-j-keerthy@ti.com> <20140709083114.GH28884@atomide.com> <53BD208E.6000507@ti.com> <20140709115106.GV28884@atomide.com> <53BE9442.4070101@ti.com>
In-Reply-To: <53BE9442.4070101@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2014 06:55 PM, Keerthy wrote:
> On Wednesday 09 July 2014 05:21 PM, Tony Lindgren wrote:
>> * Keerthy <a0393675@ti.com> [140709 04:03]:
>>> On Wednesday 09 July 2014 02:01 PM, Tony Lindgren wrote:
>>>> * Keerthy <j-keerthy@ti.com> [140708 22:40]:
>>>>> The patch series adds the device tree nodes and the corresponding
>>>>> documentation. The series also enabled tps65218 config options
>>>>> in the omap2plus_defconfig.
>>>>>
>>>>> The series is boot tested on both AM43x-epos-evm and AM437x-gp-evm.
>>>> Are the .dts changes safe to apply separately without breaking
>>>> anything?
>>> Tony,
>>>
>>> Patch 1/7 had to be re-based on Mark's latest branch for tps65218.
>>> Other patches can be taken as is. These patches are boot tested on
>>> both am437x-gp-evm and am43x-epos-evm.
>> OK thanks applying patches 4 - 7 into omap-for-v3.17/dt.
>>
>> Tony
>
> Thanks Tony.
>
> Mark,
>
> Could you please pull patch 2 and patch 3? The documentation is missing.
>

https://patchwork.kernel.org/patch/4511721/
and
https://patchwork.kernel.org/patch/4511751/

Regards,
Keerthy
> Kind Regards,
> Keerthy

