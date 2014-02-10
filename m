Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaBJIOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:14:33 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:36397 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaBJIOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:14:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAEPRUYqYq5g_98xnegKg7KLczkttVwOp3_+uEO1cRQE5GoP-fg@mail.gmail.com>
References: <1391503770.19947.0.camel@phoenix>
	<52F149F4.6040105@broadcom.com>
	<CACRpkdY4rQC30idfYP0bJHeHL-OMbH=oSNaKf8pBfUP1f+sYBg@mail.gmail.com>
	<CAEPRUYroQYzxsW-WirQ9ZW9XsSvnO7aSxun7JZoF1=3iONu-rQ@mail.gmail.com>
	<CAEPRUYqYq5g_98xnegKg7KLczkttVwOp3_+uEO1cRQE5GoP-fg@mail.gmail.com>
Date: Mon, 10 Feb 2014 09:14:31 +0100
Message-ID: <CACRpkdZGPv8658ZA=6t_gf0U+tAh19B2XCnmtsFotyZfkQs6VQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: capri: Make capri_pinctrl_probe static
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>
Cc: Olof Johansson <olof@lixom.net>, Matt Porter <mporter@linaro.org>,
        Sherman Yin <syin@broadcom.com>, Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 8:01 PM, Christian Daudt <bcm@fixthebug.org> wrote:
> On Fri, Feb 7, 2014 at 10:35 AM, Christian Daudt <bcm@fixthebug.org> wrote:
>> On Thu, Feb 6, 2014 at 1:21 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Tue, Feb 4, 2014 at 9:13 PM, Sherman Yin <syin@broadcom.com> wrote:
>>>> On 14-02-04 12:49 AM, Axel Lin wrote:
>>>>>
>>>>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>>>>>
>>>> Note that this will collide with the capri->bcm281xx renaming patches.
>>>>
>>>> Linus, Christian, are those patches going in soon?
>>>
>>> I have ACKed it, expecting it to be funneled through ARM SoC.
>>>
>>> Yours,
>>> Linus Walleij
>>
>> Linus, just to confirm. the bcm_defconfig portion is the only one
>> going through armsoc right ?
>>
>>  thanks,
>>    csd
>
> Linus,
>  Sorry for the noise. I just had a chat with Olof on irc and it is
> probably best to revert to v1 and push a single patch through, either
> through pinctrl or armsoc. If you have further patches for 3.14 could
> you pull this one in along with it ? If not then I'll ask Olof to pull
> it in instead.

Not quite following, I have ACKed the patches, so please push
whatever changes you need done through ARM SoC as this is
basically a device tree problem.

Yours,
Linus Walleij
