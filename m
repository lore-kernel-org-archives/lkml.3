Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3LMEEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 23:04:35 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41350 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3LMEEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 23:04:33 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZSyiA1zF3VcGrT+2yu3X5=eoon=0rqr7UejY4kjf7jNw@mail.gmail.com>
References: <1386784327-22164-1-git-send-email-prabhakar.csengg@gmail.com> <CACRpkdZSyiA1zF3VcGrT+2yu3X5=eoon=0rqr7UejY4kjf7jNw@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 13 Dec 2013 09:34:12 +0530
Message-ID: <CA+V-a8sFpMJce19o9USBFzG2qnxtUrfdLVKPi8em6RnYA5Tfuw@mail.gmail.com>
Subject: Re: [PATCH v7] gpio: davinci: use {readl|writel}_relaxed() instead of __raw_*
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Dec 13, 2013 at 2:01 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Dec 11, 2013 at 6:52 PM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch replaces the __raw_readl/writel with
>> {readl|writel}_relaxed(), Altough the code runs on ARMv5
>> based SOCs, changing this will help copying the code
>> for other uses.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  This patch is part of series [1] rest of the patches
>>  are Acked/reviewed so posting this patch independently
>>  and marking it as v7.
>>
>>  [1] http://www.spinics.net/lists/devicetree/msg13037.html
>>
>>  drivers/gpio/gpio-davinci.c |   36 ++++++++++++++++++------------------
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
Thanks for the Ack.

> Should I take this into the GPIO tree, or should it go
> in through the DaVinci tree?
>
To avoid dependencies its better it goes via DaVinci tree.

Thanks,
--Prabhakar Lad
