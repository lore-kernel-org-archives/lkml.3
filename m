Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaEPPcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:32:08 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17404 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbaEPPcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:32:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 16 May 2014 08:26:40 -0700
Message-ID: <53762EE4.6000808@nvidia.com>
Date: Sat, 17 May 2014 00:29:40 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: make of_get_named_gpiod_flags() private
References: <1399175125-6430-1-git-send-email-acourbot@nvidia.com>	<CACRpkdYM5W2oVT0y25u+BhWHpVma5fRP8MgmEH46dAyu8L8-2g@mail.gmail.com>	<CAAVeFuLqF6d+-BHhFzL+w9bFNxbxWV97dsx1Kbd2GD1PNf3UFg@mail.gmail.com> <CACRpkdYPcG-16aeMRKdbqGiz+coXE68p3u_tZNV2cYJgdp6j0g@mail.gmail.com>
In-Reply-To: <CACRpkdYPcG-16aeMRKdbqGiz+coXE68p3u_tZNV2cYJgdp6j0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2014 12:25 AM, Linus Walleij wrote:
> On Tue, May 13, 2014 at 3:23 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
>> On Tue, May 13, 2014 at 10:17 PM, Linus Walleij
>> <linus.walleij@linaro.org> wrote:
>
>>>> This results in all references to gpiod_* functions in of_gpio.h being
>>>> gone, which is the way it should be since this file is part of the old
>>>> integer GPIO interface.
>>>>
>>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>>
>>> This patch broke a lot of drivers so I had to take it out again...
>>
>> That's unexpected - what happens with it?
>
> I got a horde of mails from Fengguang's autobuilder, I think you got
> them as well ... else tell me and I'll dig them up.

Mmm, it seems like I didn't get any mail. Could you follow othem r point 
me to where these results are visible?

Thanks,
Alex.
