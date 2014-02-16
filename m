Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaBPXvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:51:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45394 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaBPXvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:51:53 -0500
Message-ID: <53014F0B.6010708@ti.com>
Date: Mon, 17 Feb 2014 08:51:39 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Mark Brown <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 00/10] Support TI Light Management Unit devices
References: <1392359410-6852-1-git-send-email-milo.kim@ti.com> <20140214101439.GA9462@lee--X1>
In-Reply-To: <20140214101439.GA9462@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 02/14/2014 07:14 PM, Lee Jones wrote:
>> Milo Kim (10):
>>    mfd: Add TI LMU driver
>>    backlight: Add TI LMU backlight common driver
>>    backlight: ti-lmu-backlight: Add LM3532 driver
>>    backlight: ti-lmu-backlight: Add LM3631 driver
>>    backlight: ti-lmu-backlight: Add LM3633 driver
>>    backlight: ti-lmu-backlight: Add LM3695 driver
>>    backlight: ti-lmu-backlight: Add LM3697 driver
>>    leds: Add LM3633 driver
>>    regulator: Add LM3631 driver
>>    Documentation: Add device tree bindings for TI LMU devices
>
> It makes it much easier to track if you send your patch set (shallow)
> threaded i.e. all patches attached to [PATCH 0/x]. Having all of the
> patches sent individually they will get split up and spread out all
> over the reviewers INBOX, which becomes unwieldy very quickly.
>
> Please see git send-email options:
>    `--[no-]thread` and `--[no-]chain-reply-to`
>

Oh, sorry. I made a mistake.

I copied patch files from my working machine and sent them by using git 
send-email.

I should run
   git send-email --thread --no-chain-reply-to *.patch

but I did for each patch file, stupidly.
   git send-email --thread --no-chain-reply-to 0000-cover.patch
   git send-email --thread --no-chain-reply-to 
0001-mfd-Add-TI-LMU-driver.patch
..
   git send-email --thread --no-chain-reply-to 
0010-Documentation-Add-device-tree-bindings-for-TI-LMU-de.patch

I'm so embarrassed..

Thanks for your advice.

Best regards,
Milo
