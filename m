Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaB0Aiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:38:54 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:52785 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaB0Aiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:38:52 -0500
MIME-Version: 1.0
In-Reply-To: <20140226104702.GA8961@mudshark.cambridge.arm.com>
References: <1393410552-21497-1-git-send-email-marc.ceeeee@gmail.com>
 <1393410552-21497-6-git-send-email-marc.ceeeee@gmail.com> <20140226104702.GA8961@mudshark.cambridge.arm.com>
From: Gregory Fong <gregory.0xf0@gmail.com>
Date: Wed, 26 Feb 2014 16:38:20 -0800
Message-ID: <CADtm3G7JcO6+Sc6Dsw1swY09F7+-KSXjsQU8CBcH-K6On2aP_Q@mail.gmail.com>
Subject: Re: [PATCH v7 5/9] ARM: Enable erratum 798181 for Broadcom Brahma-B15
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Carino <marc.ceeeee@gmail.com>, Christian Daudt <bcm@fixthebug.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Wed, Feb 26, 2014 at 2:47 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Feb 26, 2014 at 10:29:08AM +0000, Marc Carino wrote:
>> From: Gregory Fong <gregory.0xf0@gmail.com>
>>
>> Broadcom Brahma-B15 (r0p0..r0p2) is also affected by Cortex-A15
>> erratum 798181, so enable the workaround for Brahma-B15.
>
> Really... *exactly* the same erratum? That sounds pretty unlikely, so I'd
> really like to be sure that the workaround we have indeed solves your
> problem (issuing a dummy TLBI to 0x0 + dsb, then followed by a dmb + clrex
> on each core). The point is that the workaround doesn't simply perform
> non-shareable invalidation on each core using IPIs.

Yes, it should be the same.  I've sent you more detail off-list.

Regards,
Gregory
