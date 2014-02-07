Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaBGTB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:01:56 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:61251 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBGTBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:01:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAEPRUYroQYzxsW-WirQ9ZW9XsSvnO7aSxun7JZoF1=3iONu-rQ@mail.gmail.com>
References: <1391503770.19947.0.camel@phoenix>
	<52F149F4.6040105@broadcom.com>
	<CACRpkdY4rQC30idfYP0bJHeHL-OMbH=oSNaKf8pBfUP1f+sYBg@mail.gmail.com>
	<CAEPRUYroQYzxsW-WirQ9ZW9XsSvnO7aSxun7JZoF1=3iONu-rQ@mail.gmail.com>
Date: Fri, 7 Feb 2014 11:01:54 -0800
Message-ID: <CAEPRUYqYq5g_98xnegKg7KLczkttVwOp3_+uEO1cRQE5GoP-fg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: capri: Make capri_pinctrl_probe static
From: Christian Daudt <bcm@fixthebug.org>
To: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>,
        Matt Porter <mporter@linaro.org>
Cc: Sherman Yin <syin@broadcom.com>, Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 10:35 AM, Christian Daudt <bcm@fixthebug.org> wrote:
> On Thu, Feb 6, 2014 at 1:21 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Tue, Feb 4, 2014 at 9:13 PM, Sherman Yin <syin@broadcom.com> wrote:
>>> On 14-02-04 12:49 AM, Axel Lin wrote:
>>>>
>>>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>>>>
>>> Note that this will collide with the capri->bcm281xx renaming patches.
>>>
>>> Linus, Christian, are those patches going in soon?
>>
>> I have ACKed it, expecting it to be funneled through ARM SoC.
>>
>> Yours,
>> Linus Walleij
>
> Linus, just to confirm. the bcm_defconfig portion is the only one
> going through armsoc right ?
>
>  thanks,
>    csd

Linus,
 Sorry for the noise. I just had a chat with Olof on irc and it is
probably best to revert to v1 and push a single patch through, either
through pinctrl or armsoc. If you have further patches for 3.14 could
you pull this one in along with it ? If not then I'll ask Olof to pull
it in instead.
 thanks,
   csd
