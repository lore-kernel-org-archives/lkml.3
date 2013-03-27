Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3C0IwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:52:25 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:53470 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3C0IwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:52:21 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYjWOk---EwS1mQfKbSskxAvV=RbephQxJhg5r44UQQQg@mail.gmail.com>
References: <20130313110630.30040.20743.sendpatchset@w520>
	<CACRpkdYjWOk---EwS1mQfKbSskxAvV=RbephQxJhg5r44UQQQg@mail.gmail.com>
Date: Wed, 27 Mar 2013 17:52:19 +0900
Message-ID: <CANqRtoSvfsVUjnN1rH83-sRNdiJYthN0C7TTjhdCsowOP5Ybtw@mail.gmail.com>
Subject: Re: [PATCH] gpio: em: Make use of devm functions
From: Magnus Damm <magnus.damm@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        horms@verge.net.au, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Mar 27, 2013 at 5:28 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Mar 13, 2013 at 12:06 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> From: Magnus Damm <damm@opensource.se>
>>
>> Update the Emma Mobile GPIO driver to make use of devm
>> functions. This simplifies the error handling and makes
>> the code more compact.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>> ---
>>
>>  Written on top of:
>>  [PATCH] gpio: em: Add Device Tree support
>
> Patch applied, hm git am complains that the patch is broken
> on line 137, then when I use patch -p1 < magnus.patch
> everything works fine. Weird.

Yes, indeed a bit weird. I actually tested the code about an hour ago,
but I used patch then.

Thanks for your help!

/ magnus
