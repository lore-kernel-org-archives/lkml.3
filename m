Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaDVN1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:27:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48706 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752616AbaDVN1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:27:18 -0400
Message-ID: <53566E34.2070709@free-electrons.com>
Date: Tue, 22 Apr 2014 15:27:16 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dev@linux-sunxi.org
Subject: Re: [PATCH v3 5/7] pinctrl: sunxi: define A31 R_PIO pin functions
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>	<1397137966-30818-6-git-send-email-boris.brezillon@free-electrons.com> <CACRpkdam1a0TUPx4rMG6mzXwRdYZgfeZdBUhk0hnWAbKVQKr=A@mail.gmail.com>
In-Reply-To: <CACRpkdam1a0TUPx4rMG6mzXwRdYZgfeZdBUhk0hnWAbKVQKr=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22/04/2014 13:47, Linus Walleij wrote:
> On Thu, Apr 10, 2014 at 3:52 PM, Boris BREZILLON
> <boris.brezillon@free-electrons.com> wrote:
>
>> The A31 SoC provides both PL and PM pio bank through the R_PIO block.
>>
>> These pins all support gpio function and can bbe assigned to system
>> peripherals (like TWI, P2WI, JTAG, ...)
>>
>> Add new compatible string to the DT bindings doc.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> PARTLY APPLIED.
>
> The patch to the DT bindings apparently depend on some
> patch that I do *NOT* have in my tree, please figure out what is
> going on here and help me figure out what and how to apply the
> changes to the bindings.

Oops: I dropped the patch documenting existing compatible strings in
this version ([1]).

>
> The hunk adding the docs was dropped from the patch, please
> develop new series on top of my pinctrl devel branch as I
> push it out.

Sure, I'll make a new patch listing all compatible strings (including
this new one) in the sunxi pinctrl DT bindings doc.

Thanks,

Boris

[1] https://lkml.org/lkml/2014/4/9/258
>
> Yours,
> Linus Walleij

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

