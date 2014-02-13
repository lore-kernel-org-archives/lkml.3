Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaBMQ3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:29:06 -0500
Received: from mail.active-venture.com ([67.228.131.205]:58952 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaBMQ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:29:04 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52FCF2CD.9000008@roeck-us.net>
Date: Thu, 13 Feb 2014 08:29:01 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Lars-Peter Clausen <lars@metafoo.de>
CC: Steven Miao <realmz6@gmail.com>, adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_ADT7310" and friends
References: <1364211831.1390.285.camel@x61.thuisdomein>	 <20130325152258.GA17467@roeck-us.net> <51507126.2040002@metafoo.de>	 <1392285474.30853.28.camel@x220> <1392287466.30853.48.camel@x220>
In-Reply-To: <1392287466.30853.48.camel@x220>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 02:31 AM, Paul Bolle wrote:
> On Thu, 2014-02-13 at 10:57 +0100, Paul Bolle wrote:
>> This issue is still present in v3.14-rc2. Guenter's suggestion is the
>> easiest way out. Should I submit a trivial patch that just removes the
>> dead code depending on never defined CONFIG_ADT7310 and
>> CONFIG_ADT7310_MODULE?
>

My suggestion was to remove the ifdefs, not the code, and if I
understand the reply correctly that won't work because in that
case multiple devices would be registered with the SPI core
on the same SPI interface.

> And that is probably also true for for CONFIG_ADT7410 and
> CONFIG_ADT7410_MODULE. See https://lkml.org/lkml/2013/5/13/497 (and my
> follow up to that message).
>

Both Jean and myself sent Reviewed-by/Acked-by feedback.
Not being the maintainers, that is pretty much all we can do.
 From there it is really up to the maintainer to accept
or reject the patches.

Sure, we both suggested that the code is messy, but cleaning
that up would or should be a separate task anyway for someone
who has both the hardware and the time/interest to do it.

Guenter

