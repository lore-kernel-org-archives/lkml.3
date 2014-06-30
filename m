Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaF3PrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:47:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42948 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaF3PrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:47:00 -0400
Message-ID: <53B18671.2080005@wwwdotorg.org>
Date: Mon, 30 Jun 2014 09:46:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] ARM: tegra: roth: pinmux fixes
References: <1403508779-25896-1-git-send-email-acourbot@nvidia.com> <53ADEB5F.5030502@wwwdotorg.org> <CAAVeFuKjfmuo0JjRnhhfbuo-Ed-QqVciAQ3g6ESCmzxhOvv0JA@mail.gmail.com>
In-Reply-To: <CAAVeFuKjfmuo0JjRnhhfbuo-Ed-QqVciAQ3g6ESCmzxhOvv0JA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 10:27 PM, Alexandre Courbot wrote:
> On Sat, Jun 28, 2014 at 7:08 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 06/23/2014 01:32 AM, Alexandre Courbot wrote:
>>> Two small but important fixes to SHIELD's pinmux configuration.
>>> The use of invalid properties caused the pinmux to not be applied
>>> at all. Also the setting for sdmmc clock lines resulted in random
>>> errors or even the impossibility to probe attached devices.
>>>
>>> Alexandre Courbot (2):
>>>   ARM: tegra: roth: fix unsupported pinmux properties
>>>   ARM: tegra: roth: enable input on mmc clock pins
>>
>> The series, applied to Tegra's for-3.17/dt branch.
>>
>> Sorry for the delay; I'd forgotten that our internal discussion resolved
>> my questions about patch 2.
> 
> Thanks! And sorry for not mirroring the discussion on the public list.
> 
>> Still looking forward to internal bugs files against the Jetson TK1 and
>> Venice2 board pinmux spreadsheets for the same issue:-)
> 
> Are the spreadsheets you are talking about the following documents?
> 
> https://github.com/NVIDIA/tegra-pinmux-scripts/blob/master/configs/jetson-tk1.board
> 
> Or do we have internal structures we need to update as well?

That's data that is extracted from the internal spreadsheets. I'll try
and remember to send you the links internally (since they wouldn't be
useful to anyone on-list).
