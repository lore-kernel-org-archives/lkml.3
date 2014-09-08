Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaIHVv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:51:28 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:40849 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaIHVv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:51:26 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbD3Ds=iPxwD57ERd=xPAyVvdVbMEfjqdtAvO-0YqT_EA@mail.gmail.com>
References: <1409159852-7249-1-git-send-email-mathieu.poirier@linaro.org>
	<1409159852-7249-9-git-send-email-mathieu.poirier@linaro.org>
	<CACRpkdbD3Ds=iPxwD57ERd=xPAyVvdVbMEfjqdtAvO-0YqT_EA@mail.gmail.com>
Date: Mon, 8 Sep 2014 15:51:26 -0600
Message-ID: <CANLsYkzrXcx9UCc6bxfKR59sjDwg=p1YhKWAS5YV0iYZNH67Gw@mail.gmail.com>
Subject: Re: [PATCH 08/11 v5] coresight: adding documentation for coresight
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "r.sengupta@samsung.com" <r.sengupta@samsung.com>,
        Robert Marklund <robbelibobban@gmail.com>,
        Tony Armitstead <Tony.Armitstead@arm.com>,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies on the late reply - I was doing a quick review of your
earlier comments before getting ready for another submission when I
remembered I hadn't address this one.  Pls see below.

On 3 September 2014 02:43, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Aug 27, 2014 at 7:17 PM,  <mathieu.poirier@linaro.org> wrote:
>
>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>>
>> Documentation for the coresight framework and drivers.
>>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> (...)
>>  Documentation/trace/coresight.txt | 237 ++++++++++++++++++++++++++++++++++++++
>
> I guess you agreed on this location? If it's ARM-specific,
> Documentation/arm/coresight.txt
> is an alternative.

I didn't have prior agreement with anyone before - it was simply
dropped there to get the conversation started.  Very well, I'll move
it to @arm.

>
>> +The file cstrace.bin can be decompressed using "ptm2human", DS-5 or Trace32.
>
> Is ptm2human a candidate for the kernel tools/ directory?

A fair amount of work would have to be invested in "ptm2human" to make
it production ready.

>
> Maybe not now but later?
>
> +root@linaro-developer:/sys/kernel/debug/coresight# ls
>
> Maybe reduce noise here:
>
> root:/sys/kernel/debug/coresight# ls
>
> The reader probably does not need to know the name of your
> development system.

Ok.

>
> Yours,
> Linus Walleij
