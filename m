Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaKDKNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:13:55 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33671 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaKDKNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:13:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141103165035.GB12011@x1>
References: <1415031356-11664-1-git-send-email-lee.jones@linaro.org>
	<CAOMZO5C2sB1GNuNE-Bi5jqMO4DqBcDW2C1O+asYkbW=8fXA7TA@mail.gmail.com>
	<20141103165035.GB12011@x1>
Date: Tue, 4 Nov 2014 11:13:50 +0100
Message-ID: <CACRpkdb-6-cjHhtLMNf_jevqqmew9u0OAL-rpFd5mfiwK6C6Ww@mail.gmail.com>
Subject: Re: [PATCH] mfd: db8500-prcmu: Provide sane error path values
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Fabio Estevam <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 5:50 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, 03 Nov 2014, Fabio Estevam wrote:
>
>> On Mon, Nov 3, 2014 at 2:15 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> >         /* Clean up the mailbox interrupts after pre-kernel code. */
>> > @@ -3179,15 +3179,14 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
>> >         irq = platform_get_irq(pdev, 0);
>> >         if (irq <= 0) {
>>
>> Shouldn't this be if (irq < 0) then?
>
> Perhaps Linus can answer that.
>
> Linus,
>
>   Is 0 a valid IRQ on the u8500 platform or not?

It is not. 0 is NO_IRQ and should be so for every system... just
the lazy and ancient ones lag behind.

Yours,
Linus Walleij
