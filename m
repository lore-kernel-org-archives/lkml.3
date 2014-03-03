Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaCCHdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:33:03 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37794 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaCCHdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:33:00 -0500
MIME-Version: 1.0
In-Reply-To: <1393830601.13719.77.camel@joe-AO722>
References: <3980699.cFzmTHesZE@daeseok-laptop.cloud.net>
	<m3bnxnpyok.fsf@t19.piap.pl>
	<CAHb8M2AS2w9VBSJS9imU07ydMOZW+M-PD-Ja3iZYSTJ=2GNa-A@mail.gmail.com>
	<1393830601.13719.77.camel@joe-AO722>
Date: Mon, 3 Mar 2014 16:33:00 +0900
Message-ID: <CAHb8M2BXf+80wRJzbB0QmuQ-n=93TUngLiv6B=AHZ_60MoDgSQ@mail.gmail.com>
Subject: Re: [PATCH 3/5 v2] Staging: cxt1e1: Fix line length over 80
 characters in hwprobe.c
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: =?EUC-KR?Q?Krzysztof_Ha=A9=A9asa?= <khalasa@piap.pl>,
        Greg KH <gregkh@linuxfoundation.org>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        Shaun Laing <shaun@xresource.ca>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think line break is a solution about long line warning. And
replacing with hex_dump() is better than managing with another patch.
So I said this improvement is separated with another patch.

Just my opinion.
If I'm wrong, I try to change as Krzysztof's comment in same patch.

Thanks.
Daeseok Youn.

2014-03-03 16:10 GMT+09:00 Joe Perches <joe@perches.com>:
> On Mon, 2014-03-03 at 16:01 +0900, DaeSeok Youn wrote:
>> 2014-03-03 15:46 GMT+09:00 Krzysztof Ha©©asa <khalasa@piap.pl>:
>> > why not use some existing *hex_dump*() instead?
>> OK. but this patch is only for fix line length over 80 characters,
>> right? If it can be improved as your comment,
>> it must be in another patch.
>
> Not true.  Always strive to improve the code in
> preference to shutting up checkpatch warnings.
>
>
