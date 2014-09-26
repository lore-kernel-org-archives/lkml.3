Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaIZHs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:48:28 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60368 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaIZHs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:48:26 -0400
MIME-Version: 1.0
In-Reply-To: <2553182.6YgvmDLuEA@wuerfel>
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
	<000d01cfd946$521304f0$f6390ed0$@samsung.com>
	<CAGhQ9VxwTS9=biwp0nCKu2bVU2aNe679aKR=HU5rd_Uaw99sUw@mail.gmail.com>
	<2553182.6YgvmDLuEA@wuerfel>
Date: Fri, 26 Sep 2014 09:48:24 +0200
Message-ID: <CAGhQ9VwAe7d7fX1Lw22ocxDSXjOZbvXdmG1u6_d5v7ptmYMYeg@mail.gmail.com>
Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from platform devices
From: Joachim Eastwood <manabian@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Douglas Anderson <dianders@chromium.org>, kgene.kim@samsung.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, naushad@samsung.com,
        Li.Xiubo@freescale.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        thomas.ab@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        Lee Jones <lee.jones@linaro.org>, sunil joshi <joshi@samsung.com>,
        b29396@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2014 09:16, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 26 September 2014 07:34:12 Joachim Eastwood wrote:
>> I am working on Cortex-M4 no-MMU platform that isn't upstream yet, btw.
>>
>
> Sorry for drifting off-topic, but this is very interesting to me. Can you
> say which one you are working on and what your timeline is for submitting
> it upstream?

It's NXP LPC18xx/43xx which is Cortex-M3/M4.

3.19 or 3.20 might be target.

Right now everything is in a github repository here:
https://github.com/manabian/linux-lpc

Most stuff are working now and I am in the process of clean it up and
adding documentation.

> I generally like to know about new platforms early, and sometimes we get
> multiple people working on the same one.

I see.

regards,
Joachim Eastwood
