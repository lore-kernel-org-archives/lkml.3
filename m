Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaBGSfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:35:22 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:60324 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaBGSfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:35:20 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdY4rQC30idfYP0bJHeHL-OMbH=oSNaKf8pBfUP1f+sYBg@mail.gmail.com>
References: <1391503770.19947.0.camel@phoenix>
	<52F149F4.6040105@broadcom.com>
	<CACRpkdY4rQC30idfYP0bJHeHL-OMbH=oSNaKf8pBfUP1f+sYBg@mail.gmail.com>
Date: Fri, 7 Feb 2014 10:35:19 -0800
Message-ID: <CAEPRUYroQYzxsW-WirQ9ZW9XsSvnO7aSxun7JZoF1=3iONu-rQ@mail.gmail.com>
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

On Thu, Feb 6, 2014 at 1:21 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Feb 4, 2014 at 9:13 PM, Sherman Yin <syin@broadcom.com> wrote:
>> On 14-02-04 12:49 AM, Axel Lin wrote:
>>>
>>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>>>
>> Note that this will collide with the capri->bcm281xx renaming patches.
>>
>> Linus, Christian, are those patches going in soon?
>
> I have ACKed it, expecting it to be funneled through ARM SoC.
>
> Yours,
> Linus Walleij

Linus, just to confirm. the bcm_defconfig portion is the only one
going through armsoc right ?

 thanks,
   csd
