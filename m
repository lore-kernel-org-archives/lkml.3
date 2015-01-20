Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbbATKcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:32:22 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:55244 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbbATKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:32:20 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ+FYQveP-ervZ5NWv0NYeYmsTwpB0jXYyUFNK4TotNSQ@mail.gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
 <1421581173-28416-9-git-send-email-ricardo.ribalda@gmail.com> <CACRpkdZ+FYQveP-ervZ5NWv0NYeYmsTwpB0jXYyUFNK4TotNSQ@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 20 Jan 2015 11:31:58 +0100
Message-ID: <CAPybu_0oYX-tErXqGi=nNm=Nm-=uW-0vN+4B=-Wsn_sDrycFQA@mail.gmail.com>
Subject: Re: [PATCH 8/8] gpio/mpc8xxx: Use of_mm_gpiochip_remove
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus

I am waiting from the confirmation of Peter if that is what he really needs.

It seems to me that the code should continue even if there is no
irqdomain created.

If we need to abort if there is no irqdomain I would rather create a
new patch with this change,  since it it is a change of the current
behaviour, so if something explodes the bisect will be easier.

I will attach to this mail a patch.

Regards

On Tue, Jan 20, 2015 at 11:17 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Sun, Jan 18, 2015 at 12:39 PM, Ricardo Ribalda Delgado
> <ricardo.ribalda@gmail.com> wrote:
>
>> Since d621e8bae5ac9c67 (Create of_mm_gpiochip_remove), there is a
>> counterpart for of_mm_gpiochip_add.
>>
>> This patch implements the remove function of the driver making use of
>> it.
>>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Alexandre Courbot <gnurou@gmail.com>
>> Cc: Peter Korsgaard <jacmet@sunsite.dk>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
> Waiting for a v2 addressing the issues pointed out by Peter on this
> patch.
>
> Yours,
> Linus Walleij



-- 
Ricardo Ribalda
