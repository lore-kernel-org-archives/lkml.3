Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3LSUPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:15:43 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60174 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3LSUPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:15:41 -0500
MIME-Version: 1.0
In-Reply-To: <20131213015158.11981.27135@quantum>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
	<1379506478-16625-23-git-send-email-lee.jones@linaro.org>
	<CACRpkdZ+kg8VEMZ6gy6CG=YK0Ycj-Ud-UuRohzKgE4UW_VUMjg@mail.gmail.com>
	<20131213015158.11981.27135@quantum>
Date: Thu, 19 Dec 2013 21:15:39 +0100
Message-ID: <CAPDyKFoVDP=wcV0FcKYMtf-y8uq2ob2Ahge2y9_HL-bVojTcgQ@mail.gmail.com>
Subject: Re: [PATCH 22/41] clk: ux500: Copy u8500_clk_init() ready for DT enablement
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 December 2013 02:51, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Linus Walleij (2013-09-20 13:59:46)
>> On Wed, Sep 18, 2013 at 2:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > Here we're using the old clock initialisation function as a template.
>> > It's necessary to remove all of the clk_register_clkdev() calls as
>> > they don't make sense when booting with Device Tree.
>> >
>> > Cc: Mike Turquette <mturquette@linaro.org>
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> I *really* like the looks of this! Mike can we have your ACK on this?
>
> Acked-by: Mike Turquette <mturquette@linaro.org>

Hi Mike,

This went in through arm soc a while ago, it is present in 3.13 rc.
Thanks for your ack, anyway.

Kind regards
Uffe

>
>>
>> Yours,
>> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
