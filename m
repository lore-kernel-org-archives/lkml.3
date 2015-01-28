Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbbA2BIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:08:52 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63388 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbbA2BIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:08:50 -0500
Message-ID: <54C8E847.10506@linaro.org>
Date: Wed, 28 Jan 2015 13:46:47 +0000
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 0/2] mmc: pwrseq: Add support to multiple gpios in pwrseq
 simple
References: <1422450981-9328-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFquQgut1ZC9Jj=rbNwRKs3Qwr5LsUy_cmY7g2L8MG657Q@mail.gmail.com>
In-Reply-To: <CAPDyKFquQgut1ZC9Jj=rbNwRKs3Qwr5LsUy_cmY7g2L8MG657Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 28/01/15 13:35, Ulf Hansson wrote:
> On 28 January 2015 at 14:16, Srinivas Kandagatla
> <srinivas.kandagatla@linaro.org> wrote:
>> This patchset adds support to reset/powerup multiple gpio pins on a given
>> sdio bus. The use case is simple, on sdio we could have multiple devices
>> like WLAN, BT which are controlled by there own reset lines. So having
>> multiple reset is something more useful in such cases.
>>
>> Without this patch I could not get BT and WLAN working at same time on IFC6410.
>>
>> Thanks,
>> srini
>>
>> Srinivas Kandagatla (2):
>>    mmc: pwrseq: Add support to control multiple gpios in simple pwrseq
>>    mmc: pwrseq: Update document with multiple gpios support
>>
>>   .../devicetree/bindings/mmc/mmc-pwrseq-simple.txt  |  7 ++-
>>   drivers/mmc/core/pwrseq_simple.c                   | 64 +++++++++++++++-------
>>   2 files changed, 49 insertions(+), 22 deletions(-)
>>
>> --
>> 1.9.1
>>
>
> Hi Srinivas,
>
> I noticed that Javier a few hours ago posted a patchset which
> implement the same thing as yours, I guess this is a wanted feature.
> :-)
yes.

>
> I am going to review Javier's patchset, would be nice if you could
> have a look at it as well.
Sure.. they look very similar..

!!!  Should have sent my patches yesterday :-)
>
> Kind regards
> Uffe
>
