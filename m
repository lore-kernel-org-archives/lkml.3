Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3LPOA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:00:58 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64767 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3LPOA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:00:56 -0500
MIME-Version: 1.0
In-Reply-To: <20131216082556.GE18769@lee--X1>
References: <CAOMwXhN5UfR=Y8V3i=A2zSCv7V9sRDd0Z+D1AQFahvRS-mV5Fw@mail.gmail.com>
	<20131216082556.GE18769@lee--X1>
Date: Mon, 16 Dec 2013 14:00:56 +0000
X-Google-Sender-Auth: e7qfri_uScPt6LpUGjfVKWwHPw4
Message-ID: <CAOMwXhN8fG8YbU53A_U_MyMTyGWfV7NCCtr2a5oCbHdB0iqqmA@mail.gmail.com>
Subject: Re: Simple MFD driver example
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, if you ask me the MFD subsystem is underdocumented, and there is
some inconsistency between the drivers. It is hard to take any of them
as a starting point, at least for me. Currently, I wrote a simple one
from scratch which I will post soon.

On Mon, Dec 16, 2013 at 8:25 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> I have been trying to write about 50-100 LOC for 1-2 weeks now. I have
>> a fairly simple use case for MFD where I need to have gpio and hwmon
>> functionality for a GPIO.
>>
>> I read the mfd drivers inside and out by now, but it looks a bit
>> inconsistent to me. I am not sure what to follow etc. The
>> documentation seems to be virtually missing which makes my life and
>> involvement even more difficult. :(
>>
>> May I ask for some pointer how to do all this? It would be nice to see
>> a minimal example where the parent does not do anything else than just
>> enumerating the sub-device drivers. Is that possible with an empty
>> probe callback?
>>
>> If I understand the regmap correctly (again, it is possible I do not),
>> then I would not need this. But in general, it is really hard to deal
>> with the linux kernel in this regard when basic documentations are
>> missing.
>>
>> I hope this would change over time for the posterity. It is a pity
>> that contributors do not join probably due to this. It is a bit
>> chaotic, but I hope it can be changed in the future.
>>
>> Apologies for my frustration...
>
> Due to the nature of the MFD subsystem, there isn't a simple use-case
> which you can use as a template. It's completely dependent on the
> device you are trying to enable. There are lots of well written
> drivers in the subsystem that you can use as good examples though.
>
> Which device are you trying to write a driver for? Is there a
> datasheet you can point to?
>
> NB: When emailing subsystem maintainers for help, please don't forget
> to CC the relevant Mailing Lists. All lists can be found in the
> MAINTAINERS file, which is parsed by <kernel>/scripts/get_maintainer.pl.
>
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
