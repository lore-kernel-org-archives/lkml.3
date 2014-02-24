Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaBXHqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:46:40 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:62891 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaBXHqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:46:38 -0500
Message-ID: <530AF8DA.8050709@cogentembedded.com>
Date: Mon, 24 Feb 2014 11:46:34 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>
CC: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, magnus.damm@gmail.com, horms@verge.net.au,
        gnurou@gmail.com, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com
Subject: Re: [PATCH] gpio: gpio-rcar: init at postcore level
References: <1393173467-12240-1-git-send-email-vladimir.barinov@cogentembedded.com> <530A477C.6070007@codethink.co.uk>
In-Reply-To: <530A477C.6070007@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ben,

On 02/23/2014 11:09 PM, Ben Dooks wrote:
> On 23/02/14 16:37, vladimir.barinov@cogentembedded.com wrote:
>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>>
>> This adds ability to use gpio API at board init_machine level.
>>
>> F.e. it can be used in the following situation.
>> Many reference hardware has onboard switches that selects which 
>> periferals
>> to connect to the system. The gpio input state from switches can be used
>> in choosing platform devices runtime in board code instead of 
>> ifdefs/defconfig
>> changes.
>
> Firstly, anyone still using platform_devices to describe their
> system needs to be stopped. We cannot go on supporting this when
> our primary boot method is supposed to be device-tree. If we keep
> doing this then we will not get any of the current issues fixed.
Understand. I see that this is not a time for such changes.
Hope that the DT model will take into account such kind of situation in 
the future.
>
> Will it impact the devicetree bindings on rcar?
No

Regards,
Vladimir
