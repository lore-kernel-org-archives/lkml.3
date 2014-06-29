Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbaF2E1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 00:27:35 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:49737 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaF2E1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 00:27:34 -0400
MIME-Version: 1.0
In-Reply-To: <53ADEB5F.5030502@wwwdotorg.org>
References: <1403508779-25896-1-git-send-email-acourbot@nvidia.com> <53ADEB5F.5030502@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 29 Jun 2014 13:27:13 +0900
Message-ID: <CAAVeFuKjfmuo0JjRnhhfbuo-Ed-QqVciAQ3g6ESCmzxhOvv0JA@mail.gmail.com>
Subject: Re: [PATCH 0/2] ARM: tegra: roth: pinmux fixes
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 7:08 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/23/2014 01:32 AM, Alexandre Courbot wrote:
>> Two small but important fixes to SHIELD's pinmux configuration.
>> The use of invalid properties caused the pinmux to not be applied
>> at all. Also the setting for sdmmc clock lines resulted in random
>> errors or even the impossibility to probe attached devices.
>>
>> Alexandre Courbot (2):
>>   ARM: tegra: roth: fix unsupported pinmux properties
>>   ARM: tegra: roth: enable input on mmc clock pins
>
> The series, applied to Tegra's for-3.17/dt branch.
>
> Sorry for the delay; I'd forgotten that our internal discussion resolved
> my questions about patch 2.

Thanks! And sorry for not mirroring the discussion on the public list.

> Still looking forward to internal bugs files against the Jetson TK1 and
> Venice2 board pinmux spreadsheets for the same issue:-)

Are the spreadsheets you are talking about the following documents?

https://github.com/NVIDIA/tegra-pinmux-scripts/blob/master/configs/jetson-tk1.board

Or do we have internal structures we need to update as well?
