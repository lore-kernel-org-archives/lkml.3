Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3KNQdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:33:02 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:56725 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3KNQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:32:54 -0500
MIME-Version: 1.0
X-Originating-IP: [139.11.160.113]
In-Reply-To: <11018682.0TjgocUWod@flatron>
References: <5283BC93.1090801@koalo.de>
	<2385512.qcT1vt8HYp@flatron>
	<CABDT8WyUK6tDneDEm0G3o0zJHXaVTZp8JAMxOp5LRKQYG-7Umw@mail.gmail.com>
	<11018682.0TjgocUWod@flatron>
Date: Thu, 14 Nov 2013 17:32:53 +0100
Message-ID: <CABDT8Wxy-aA5CbZUSXRtod3i_9rBhXqGyGi+tBYGkYtygQmmpw@mail.gmail.com>
Subject: Re: [PATCHv4] dmaengine: Add support for BCM2835
From: Florian Meier <florian.meier@koalo.de>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Matt Porter <matt.porter@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/14 Tomasz Figa <tomasz.figa@gmail.com>:
> On Thursday 14 of November 2013 17:14:31 Florian Meier wrote:
>> >> >> I am becoming desperate anyway that this migration will ever fully
>> >> >> take place....
>> >> >
>> >> > Why not? It's just a matter of people like you working on this (and
>> >> > addressing some review comments ;)).
>> >>
>> >> The most common comment about this is that people will not put effort in
>> >> the upstream kernel as long as there is no comfortable way for debugging
>> >> in the upstream kernel (i.e. at least USB support).......
>> >
>> > Right, you need USB to have ethernet working. Still, IMHO UART (for
>> > console) + ethernet (for file transfer or NFS root) is the reasonable
>> > setup allowing you to debug further drivers in a comfortable way.
>>
>> I am fine with UART and switching SD cards :-)
>> But apparently this is not generally accepted.
>
> Still, isn't some work on USB support for RPi already going on? I believe
> Matt Porter (now on Cc) has been working on unifying dwc2 host-mode
> driver with Samsung s3c-hsotg device-mode driver (for the same IP) to
> get full OTG support on all applicable platforms.

That sounds great! I never heard about that.
Maybe some day it really happens that Raspbian uses the upstream kernel :-)
