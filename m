Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3IROM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:12:29 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:55636 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab3IROM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:12:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130917235028.GR9994@atomide.com>
References: <201302171616.50152@pali> <20130217190303.GC2317@blackmetal.musicnaut.iki.fi>
 <201303062112.06417@pali> <201309062234.05878@pali> <20130907230252.GA10700@blackmetal.musicnaut.iki.fi>
 <20130917235028.GR9994@atomide.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Wed, 18 Sep 2013 16:12:06 +0200
Message-ID: <CAAwP0s3MBd58Q9wijQP9Nd_DB4GdicE-b427cHS-UXYS4HW-Jg@mail.gmail.com>
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 1:50 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Aaro Koskinen <aaro.koskinen@iki.fi> [130907 16:10]:
>> Hi,
>>
>> On Fri, Sep 06, 2013 at 10:34:05PM +0200, Pali Rohár wrote:
>> > > --- /dev/null
>> > > +++ b/arch/arm/mach-omap2/board-rx51-camera.c
>> [...]
>> > Ping, can you review this patch v2?
>>
>> I don't think Tony will accept any new board stuff for RX-51/N900.
>> See for example: http://marc.info/?l=linux-kernel&m=137629626213187&w=2
>>
>> There should be initial Nokia N900 DTS file in 3.12-rc1, and we should
>> continue converting this board fully to DT.
>
> Yes let's plan on making mach-omap2 to be DT only soonish.
> AFAIK the only stopper right now for omap3 are the pending
> pinctrl changes for the wake-up events as otherwise we would
> have sever PM regressions with off-idle.
>

Hi Tony,

I don't know if OMAP2+ DT will happen soon as you said. At least I
know about a big issue we had with GPIO pins not being auto-requested
when are mapped as IRQ. You can refer to [1] for the latest approach
and how this discussion have been going.

This is something that we have been trying to solve for a couple of
kernel releases by now so it would be great if you can join the
discussion.

> Regards,
>
> Tony

Thanks a lot and best regards,
Javier

[1]: https://lkml.org/lkml/2013/8/26/260
