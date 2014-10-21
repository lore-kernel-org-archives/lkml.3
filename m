Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbaJUVBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:01:34 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:39764 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbaJUVBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:01:32 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:3592:c0b0:1605:7f56]
In-Reply-To: <5446C775.3030707@suse.de>
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
	<CAOesGMjAb5oXjauhbqjDhJXWct7qoXxy3XpA1=DioK7vPTwetA@mail.gmail.com>
	<5446C775.3030707@suse.de>
Date: Tue, 21 Oct 2014 14:01:31 -0700
Message-ID: <CAOesGMhSuvbWpM5CC_5Hy6BskM6sbrw0SCR90aKHvfk1Qm1_Ng@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
From: Olof Johansson <olof@lixom.net>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 1:52 PM, Andreas Färber <afaerber@suse.de> wrote:
> Hi Olof and Sören,
>
> Am 18.10.2014 um 06:28 schrieb Olof Johansson:
>> On Thu, Jul 24, 2014 at 4:00 PM, Andreas Färber <afaerber@suse.de> wrote:
>>> Hello,
>>>
>>> This patch series adds an initial device tree for the Parallella board.
>>> UART, SD card, Ethernet are enabled.
>>> Not yet enabled are HDMI, QSPI flash and 2x USB.
>>
>> Andreas (Olofsson) kindly sent me a board, and I added it to the boot
>> farm today, it'll be included in boot reports from here on.
>
> Good to hear.
>
>> I did a test run with yesterday's -next It looks like networking isn't
>> working there at the moment, clock related. Same happens with 3.17 and
>> latest mainline, config multi_v7_defconfig:
>>
>> [WARN] [    7.943648] macb e000b000.ethernet eth0: unable to generate
>> target frequency: 125000000 Hz
>> [WARN] [   10.948681] macb e000b000.ethernet eth0: unable to generate
>> target frequency: 125000000 Hz
>
> I am unable to reproduce this in my setup - at Linus' tip
> c2661b806092d8ea2dccb7b02b65776555e0ee47 (v3.18-rc1-68-gc2661b8), make
> oldconfig'ing my /proc/config.gz.
>
> Sören, in light of your explanations, should I be expecting problems
> with 1GbE or with 100MbE? My board is connected to a 1GbE switch.

My board might have old firmware/bitstream on it? It reports as:

U-Boot 2012.10-00003-g792c31c (Jan 03 2014 - 12:24:08)


-Olof
