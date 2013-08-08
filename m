Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966862Ab3HHWtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 18:49:40 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:49080 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966810Ab3HHWtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 18:49:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1308090013440.21412@pmeerw.net>
References: <1375980335-19943-1-git-send-email-ricardo.ribalda@gmail.com>
 <1375980335-19943-2-git-send-email-ricardo.ribalda@gmail.com>
 <CAK5ve-+nnAGAnFNb6=QuekDMQwJ7w7h7k67dES0=wTN07n-9NA@mail.gmail.com> <alpine.DEB.2.01.1308090013440.21412@pmeerw.net>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 8 Aug 2013 15:49:17 -0700
Message-ID: <CAK5ve-L3XKMYMRjX8MX=i4ppNixZB=2FjO48_pxRnXvaco_DWg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] leds-pca9633: Add support for PCA9634
To: Peter Meerwald <p.meerwald@bct-electronic.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 3:36 PM, Peter Meerwald
<p.meerwald@bct-electronic.com> wrote:
> Hello,
>
>> > Add support for PCA9634 chip, which belongs to the same family as the
>> > 9633 but with support for 8 outputs instead of 4.
>
>> Basically I like this method to add a new chip supporting. Please find
>> my comments below.
>
> me too :)
>
>> What about just rename the whole file to leds-pca963x.c. And rename
>> some pca9633 to pca963x in the driver.
>
> there are other, similar I2C LED driver chips which might be
> handled with the current pca9633 driver, e.g. the pca9685 (which is
> supported under pwm/ by the way)
>
> people have argued that the numbering scheme of chips is hard to
> predict; hence, the driver name should be determined by the first
> device supported to avoid subsequent renaming -- but I have no strong
> feelings about this
>

Giving a more generic and meaningful name of this driver should be a
easier for people to understand. So if pca9685 is coming, we can use
leds-pca96xx.c and pca96xx for this pca96xx chip family, as long as
they can share this driver code.

Please take a look at Milo did in leds-lp55xx drivers.

Thanks a lot,
-Bryan
