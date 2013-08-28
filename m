Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3H1NHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:07:00 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57107 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3H1NG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:06:59 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.156.156]
In-Reply-To: <CACRpkdbJMG-MbBrt19kj_NTrarhcHfDCppciuL93fT95Mby7MA@mail.gmail.com>
References: <1377613817.14731.1.camel@phoenix>
	<CACRpkdbJMG-MbBrt19kj_NTrarhcHfDCppciuL93fT95Mby7MA@mail.gmail.com>
Date: Wed, 28 Aug 2013 21:06:58 +0800
Message-ID: <CAFRkauBDLBu6BEooAnZTAzYUgrBwTLPmRoLejzLEHDzikU5JFA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: rockchip: Implement .request() and .free()
 callbacks on the GPIO chips
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/28 Linus Walleij <linus.walleij@linaro.org>:
> On Tue, Aug 27, 2013 at 4:30 PM, Axel Lin <axel.lin@ingics.com> wrote:
>
>> Implement .request() and .free() callbacks on the GPIO chips to inform pinctrl
>> when a GPIO is requested or freed.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> ---
>
> Ohhh that will have semantic effects so really need to wait
> for Heiko's opinion on this one.
>
> BTW: Axel are you working with this system?

No, I don't have a rockchip platform.

But I'm writting a pinctrl driver for an ARM SoC.
So I read a couple pinctrl driver source code for reference.

Regards,
Axel
