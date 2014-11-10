Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaKJLNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:13:31 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33226 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaKJLN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:13:29 -0500
Message-ID: <54609DD8.8030903@cogentembedded.com>
Date: Mon, 10 Nov 2014 14:13:28 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>, wsa@the-dreams.de,
        ludovic.desroches@atmel.com
CC: khilman@kernel.org, nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] i2c/at91: adopt pinctrl support
References: <1415584552-11390-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1415584552-11390-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/10/2014 4:55 AM, Wenyou Yang wrote:

> Amend the at91 i2c pin controller

    You're amending the hardware itself, really? :-)

> to optionally take a pin controlhandle

    I don't see the code that does this.

> and set the state of the pins to:
> - "default" on boot and resume.

    I don't see where you are changing anything for the probe() method. 
Perhaps you meant the driver core code which selects the dafault profile 
automatically?

> - "sleep" on suspend().

> This should make it possible to optimize energy usage for the pins
> both for the suspend/resume cycle

> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
> Hi Wolfram,
>
> Thanks a lot.
>
> The change of this version is to remove
> 	pinctrl_pm_select_default_state(&pdev->dev) from the _probe function.

    Aha, you've specifically removed this...

WBR, Sergei

