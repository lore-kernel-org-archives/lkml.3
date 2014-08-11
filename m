Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbaHKWGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:06:18 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:43459 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaHKWGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:06:15 -0400
MIME-Version: 1.0
In-Reply-To: <53E8EBBD.6080500@roeck-us.net>
References: <1406139132-5404-1-git-send-email-linux@roeck-us.net>
 <CAAVeFuKsJpSYo2DMyTdYE2J5Cu_ZD=b9o-=S0DLDccyNmwniNg@mail.gmail.com>
 <53D0A8B7.2010005@roeck-us.net> <CAAVeFuK5uKhpkpEnoRFGKU4G4Fey0+giz5wwmtr+OCLJHPvnLQ@mail.gmail.com>
 <53E32C09.5000704@roeck-us.net> <CAAVeFuJohBznnjELvJj0OUCK+anbZ-j1xPc9gyKDGVq9X0MDSA@mail.gmail.com>
 <53E8DE1D.9070503@roeck-us.net> <CAAVeFuK8kb3kopVaM9qz+qOa4RT_oji8LNLQa_UHDxxxwyfZgw@mail.gmail.com>
 <53E8EBBD.6080500@roeck-us.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 11 Aug 2014 15:05:54 -0700
Message-ID: <CAAVeFuKE8z6JunJT-pE5wyjEBR5KvEUZoh5pASzhg1n2qsWcag@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib: Provide and export gpiod_export_name
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 9:13 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 08/11/2014 08:20 AM, Alexandre Courbot wrote:
> [ ... ]
>
>>
>> Note that this doesn't change anything to the core of the argument ;
>> we have not heard what Linus thinks about named GPIOs in
>> /sys/class/gpio yet, maybe he will have a different opinion...
>>
>
> Well, please let me know if/when you are planning to take away
> that existing ABI so I can plan accordingly. FWIW, out-of-kernel
> users I am currently aware of are Juniper Networks and Zodiac
> Aerospace. The latter asked me to help them upstreaming their code.
>
> If you plan to remove the ABI, you might want to inform its current
> in-kernel users. You can look those up yourself.

We are not taking existing user-space ABIs away. But we are also not
encouraging people to use bad ABIs by introducing new ways to use
them, hence my restraint towards this patch.
