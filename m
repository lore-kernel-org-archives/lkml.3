Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3FNQlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:41:39 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:36500 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab3FNQlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:41:37 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <2428901.voOA9oET8R@wuerfel>
References: <1371040448-28742-1-git-send-email-jonas.jensen@gmail.com>
	<1371040448-28742-2-git-send-email-jonas.jensen@gmail.com>
	<2428901.voOA9oET8R@wuerfel>
Date: Fri, 14 Jun 2013 09:41:36 -0700
Message-ID: <CAOesGMgznJXWN5nE-2igC-d0YY_aFk0Q1D_5p95oTZM-VTs5qw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: mach-moxart: add MOXA ART SoC files
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 7:47 AM, Arnd Bergmann <arnd@arndb.de> wrote:
arch.h>
>> +
>> +static const char * const moxart_dt_compat[] = {
>> +     "moxa,moxart-uc-7112-lx",
>> +     NULL,
>> +};
>> +
>> +DT_MACHINE_START(MOXART, "MOXA UC-7112-LX")
>> +     .dt_compat              = moxart_dt_compat,
>> +MACHINE_END
>
> If the .dt_compat fields is the only field in the machine descriptor,
> you can leave out the entire descriptor!
>
> Olof, do you have a preference to how we want to handle this? The
> only advantage of having this file at all is to have the
> "MOXA UC-7112-LX" string in /proc/cpuinfo.
> Should we just remove the entire directory or leave it as the trivial
> file above?

I sort of presumed that there might be need for _some_ platform code
later on, just not quite yet, so I didn't want to be quite that
drastic. I suppose leaving it with the trivial file for now is OK, and
we can make a sweeping change down the road in case we want to clean
up and consolidate all the trivial platforms.


-Olof
