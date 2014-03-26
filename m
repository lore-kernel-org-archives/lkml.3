Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaCZP3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:29:41 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:47970 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbaCZP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:29:39 -0400
Message-ID: <5332F25E.10104@gmail.com>
Date: Wed, 26 Mar 2014 10:29:34 -0500
From: Dinh Nguyen <dinh.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        delicious quinoa <delicious.quinoa@gmail.com>
CC: Alan Tull <atull@altera.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: dts: socfpga: add gpio pieces
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>	<1395345324-18299-4-git-send-email-bigeasy@linutronix.de>	<CANk1AXRa4V1ADNaT+T3pYF4zyxni9Y8rmU9UYRoA_7NxW8KWEg@mail.gmail.com> <CANk1AXSQVFZvRmvYt+JF+TDVpfX-_RLiUcQXotGzpHoTMUVymQ@mail.gmail.com> <532D73D1.7020408@linutronix.de>
In-Reply-To: <532D73D1.7020408@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/22/2014 06:28 AM, Sebastian Andrzej Siewior wrote:
> On 03/21/2014 11:15 PM, delicious quinoa wrote:
>> snps,nr-gpios = <27>;
>>
>> As noted on other thread, gpio2 is 27 wide, despite what the
>> documentation says.  When I made that change and remove your other two
>> patches the gpios worked for me on a cyclone5 devkit board.
>>
>> So if you fix the "#gpio-cells = <2>;" for all 3 gpios and fix
>> "snps,nr-gpios = <27>;" for gpio2, then this one patch looks good to
>> me.  With these changes,
>
> Okay will do. And I also add a note that  the reference manual is wrong
> here.
>

I've applied this patch to rocketboards/linux-socfpga-next/next-dt. I 
will take through the arm-soc tree for 3.16.

Dinh
>>
>> Acked-by: Alan Tull <atull@altera.com>
>>
>> Alan Tull
>> aka
>> delicous quinoa
>
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
