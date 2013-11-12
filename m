Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab3KLBHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:07:00 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:52546 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3KLBGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <1383881076.9263.64.camel@joe-AO722>
References: <20131101134120.13a44225@notabene.brown> <CAK5ve-LzYLr0xuvNA3MX=pECPPfAkDFqExPpmQt8GF+9jf5uHg@mail.gmail.com>
 <20131108142004.10e31655@notabene.brown> <1383881076.9263.64.camel@joe-AO722>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 11 Nov 2013 17:06:28 -0800
Message-ID: <CAK5ve-LWqoHPjKxMXbqzvazHyoNF+3pZ5fh022xaEVAjY_vXqQ@mail.gmail.com>
Subject: Re: PATCH] LEDS: tca6507 - fix up some comments.
To: Joe Perches <joe@perches.com>
Cc: NeilBrown <neilb@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 7:24 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2013-11-08 at 14:20 +1100, NeilBrown wrote:
>> In particular fix the capitalisation of GPIO and LED and
>> correct TCA6507_MAKE_CPIO, but also rewrite the comment about
>> platform-data to include reference to devicetree.
>
> trivia:
>
>> diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
> []
>> @@ -8,7 +8,7 @@
>>   * double-blink.
>>   *
>>   * This driver can configure each line either as a 'GPIO' which is out-only
>> - * (no pull-up) or as an LED with variable brightness and hardware-assisted
>> + * (pull-up resistor required) or as an LED with variable brightness and hardware-assisted
>>   * blinking.
>
> Please rewrap the comment to 80 cols.
>
>

Hi Neil,

Could you update your patch according Joe's review.

Thanks,
-Bryan
