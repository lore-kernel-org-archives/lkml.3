Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3LJTic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:38:32 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34116 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3LJTia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:38:30 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <201312102033.00953.arnd@arndb.de>
References: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<52A674F1.7000104@gmail.com>
	<20131210191653.GA10105@quad.lixom.net>
	<201312102033.00953.arnd@arndb.de>
Date: Tue, 10 Dec 2013 11:38:29 -0800
Message-ID: <CAOesGMhMAC56AK5YwA2ROzQ5b6HuWXzF31HDCyx7fYzka6WvHQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] ARM: Initial support for Marvell Berlin SoCs
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 10 December 2013, Olof Johansson wrote:
>> > I started with mach-mvebu in the first RFC, but Berlin SoCs are from a
>> > different business unit at Marvell and are more PXA compatible than
>> > Orion/Kirkwood/Armada 370/XP. Most notably, they lack the "mbus" and
>> > IP is either from PXA/MMP or Synopsys DW. Thomas Petazzoni and also
>> > Jisheng Zhang from Marvell suggested to not put it into mvebu but
>> > have a different mach folder instead.
>>
>> Hmm, ok. Well, maybe later on we can look at aggregating them more again. It'd
>> be nice to get fewer top-level platform directories per vendor.
>
> I possibly a lot of directories just become empty in the long run and
> we remove them once all all code has been subsystemized and drivered.

For mobile SoCs it's somewhat unlikely that it will ever be completely
empty, but maybe. Either way, once the contents is small enough it's a
lot easier to move around and aggregate into one platform.

-Olof
