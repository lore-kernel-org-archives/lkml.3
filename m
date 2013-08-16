Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3HPQ3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:29:39 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37185 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab3HPQ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:29:36 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbOPL7K2yc_zAo0-b-Y0mXCRXJfc7YYDhcb0K3uj76BBQ@mail.gmail.com>
References: <1376490038-32382-1-git-send-email-ricardo.ribalda@gmail.com> <CACRpkdbOPL7K2yc_zAo0-b-Y0mXCRXJfc7YYDhcb0K3uj76BBQ@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 16 Aug 2013 18:29:15 +0200
Message-ID: <CAPybu_3VLzn08Y2Kq3Wn6g+UkaWG5mnMdm3Xdqghat6qN2Ah=g@mail.gmail.com>
Subject: Re: [PATCH] gpio-pca953x: Fix read for chips with more than 8 gpios
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Ruder <andy@aeruder.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus

I tried to google it when I sent it, but I didnt found anything. Glad
to hear it is alreay in the queue :)

Regards!

On Fri, Aug 16, 2013 at 5:21 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Aug 14, 2013 at 4:20 PM, Ricardo Ribalda Delgado
> <ricardo.ribalda@gmail.com> wrote:
>
>> pca953x_read_single returns ONLY the value of the 8 inputs of the
>> same bank.
>>
>> off can have a value from 0 to 15, therefore we have to find the
>> offset of that gpio within that bank.
>>
>> Without this patch gpios 8-15 will always be read as zero.
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
> Nice! But it turns out I already had an identical patch by
> Andrew Ruder acked by Gregory Clement in my patch queue.
>
> Yours,
> Linus Walleij



-- 
Ricardo Ribalda
