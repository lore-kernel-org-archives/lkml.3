Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbaDIOpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:45:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33117 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932781AbaDIOpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:45:53 -0400
Message-ID: <53455D20.1090804@free-electrons.com>
Date: Wed, 09 Apr 2014 16:45:52 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 06/15] clk: sunxi: add A31 APB0 gates compatible string
 to the documentation
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com> <1397051478-4113-7-git-send-email-boris.brezillon@free-electrons.com> <CAGb2v645Yu_1ODQhVcQjjFf1M0uf3aHBfRw4F_uhoYk9RozcOA@mail.gmail.com>
In-Reply-To: <CAGb2v645Yu_1ODQhVcQjjFf1M0uf3aHBfRw4F_uhoYk9RozcOA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/04/2014 15:59, Chen-Yu Tsai wrote:
> Hi,
>
> On Wed, Apr 9, 2014 at 9:51 PM, Boris BREZILLON
> <boris.brezillon@free-electrons.com> wrote:
>> Add the new "allwinner,sun6i-a31-apb0-gates-clk" compatible string to the
>> sunxi clock documentation.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  Documentation/devicetree/bindings/clock/sunxi.txt | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
>> index c2cb762..bc30387 100644
>> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
>> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
>> @@ -25,6 +25,7 @@ Required properties:
>>         "allwinner,sun4i-apb0-gates-clk" - for the APB0 gates on A10
>>         "allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
>>         "allwinner,sun5i-a10s-apb0-gates-clk" - for the APB0 gates on A10s
>> +       "allwinner,sun6i-a31-apb0-gates-clk" - for the APB0 gates on A10s
>                                                                        ^^^^
> Copy paste error here.

Oops, it'll be fixed in the next version.

>
>
> ChenYu
>
>>         "allwinner,sun7i-a20-apb0-gates-clk" - for the APB0 gates on A20
>>         "allwinner,sun4i-apb1-clk" - for the APB1 clock
>>         "allwinner,sun4i-apb1-mux-clk" - for the APB1 clock muxing

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

