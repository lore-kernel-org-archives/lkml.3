Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3LPI0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:26:03 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50526 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3LPI0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:26:00 -0500
Date: Mon, 16 Dec 2013 08:25:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: Simple MFD driver example
Message-ID: <20131216082556.GE18769@lee--X1>
References: <CAOMwXhN5UfR=Y8V3i=A2zSCv7V9sRDd0Z+D1AQFahvRS-mV5Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhN5UfR=Y8V3i=A2zSCv7V9sRDd0Z+D1AQFahvRS-mV5Fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have been trying to write about 50-100 LOC for 1-2 weeks now. I have
> a fairly simple use case for MFD where I need to have gpio and hwmon
> functionality for a GPIO.
> 
> I read the mfd drivers inside and out by now, but it looks a bit
> inconsistent to me. I am not sure what to follow etc. The
> documentation seems to be virtually missing which makes my life and
> involvement even more difficult. :(
> 
> May I ask for some pointer how to do all this? It would be nice to see
> a minimal example where the parent does not do anything else than just
> enumerating the sub-device drivers. Is that possible with an empty
> probe callback?
> 
> If I understand the regmap correctly (again, it is possible I do not),
> then I would not need this. But in general, it is really hard to deal
> with the linux kernel in this regard when basic documentations are
> missing.
> 
> I hope this would change over time for the posterity. It is a pity
> that contributors do not join probably due to this. It is a bit
> chaotic, but I hope it can be changed in the future.
> 
> Apologies for my frustration...

Due to the nature of the MFD subsystem, there isn't a simple use-case
which you can use as a template. It's completely dependent on the
device you are trying to enable. There are lots of well written
drivers in the subsystem that you can use as good examples though.

Which device are you trying to write a driver for? Is there a
datasheet you can point to?

NB: When emailing subsystem maintainers for help, please don't forget
to CC the relevant Mailing Lists. All lists can be found in the
MAINTAINERS file, which is parsed by <kernel>/scripts/get_maintainer.pl.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
