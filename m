Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3LRNKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:10:16 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62804 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3LRNKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:10:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAEgOgz7kqU-Z6cQk8kiMBiNs=9coOVq-6it1eKEiN62wKXcsZg@mail.gmail.com>
References: <1387294714-12872-1-git-send-email-jonas.jensen@gmail.com>
	<1387294714-12872-3-git-send-email-jonas.jensen@gmail.com>
	<CAEgOgz7kqU-Z6cQk8kiMBiNs=9coOVq-6it1eKEiN62wKXcsZg@mail.gmail.com>
Date: Wed, 18 Dec 2013 14:10:13 +0100
Message-ID: <CACmBeS2amFHRQM9HB5pvT5eZYYidWHDNBsWEvSpMKAy7yCqmPw@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] ARM: mach-moxart: add MOXA ART SoC device tree files
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux@roeck-us.net" <linux@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the replies, changes should be in v6.

On 18 December 2013 00:29, Peter Crosthwaite
<peter.crosthwaite@xilinx.com> wrote:
>> +       clocks {
>> +               #address-cells = <1>;
>> +               #size-cells = <0>;
>> +
>> +               ref12: ref12M {
>> +                       compatible = "fixed-clock";
>> +                       #clock-cells = <0>;
>> +                       clock-frequency = <12000000>;
>
> Crystal board level?

I couldn't move this due to fixed-clock load order.

See my comments in v6 cover letter:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/220302.html


Thanks,
Jonas
