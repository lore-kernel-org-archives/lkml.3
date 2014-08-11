Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaHKQNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:13:55 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58146 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaHKQNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:13:53 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E8EBBD.6080500@roeck-us.net>
Date: Mon, 11 Aug 2014 09:13:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH] gpiolib: Provide and export gpiod_export_name
References: <1406139132-5404-1-git-send-email-linux@roeck-us.net> <CAAVeFuKsJpSYo2DMyTdYE2J5Cu_ZD=b9o-=S0DLDccyNmwniNg@mail.gmail.com> <53D0A8B7.2010005@roeck-us.net> <CAAVeFuK5uKhpkpEnoRFGKU4G4Fey0+giz5wwmtr+OCLJHPvnLQ@mail.gmail.com> <53E32C09.5000704@roeck-us.net> <CAAVeFuJohBznnjELvJj0OUCK+anbZ-j1xPc9gyKDGVq9X0MDSA@mail.gmail.com> <53E8DE1D.9070503@roeck-us.net> <CAAVeFuK8kb3kopVaM9qz+qOa4RT_oji8LNLQa_UHDxxxwyfZgw@mail.gmail.com>
In-Reply-To: <CAAVeFuK8kb3kopVaM9qz+qOa4RT_oji8LNLQa_UHDxxxwyfZgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 08:20 AM, Alexandre Courbot wrote:
[ ... ]
>
> Note that this doesn't change anything to the core of the argument ;
> we have not heard what Linus thinks about named GPIOs in
> /sys/class/gpio yet, maybe he will have a different opinion...
>

Well, please let me know if/when you are planning to take away
that existing ABI so I can plan accordingly. FWIW, out-of-kernel
users I am currently aware of are Juniper Networks and Zodiac
Aerospace. The latter asked me to help them upstreaming their code.

If you plan to remove the ABI, you might want to inform its current
in-kernel users. You can look those up yourself.

Thanks,
Guenter

