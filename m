Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbaJRE2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 00:28:06 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:62847 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaJRE2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 00:28:04 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1406242820-20140-1-git-send-email-afaerber@suse.de>
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
Date: Fri, 17 Oct 2014 21:28:02 -0700
Message-ID: <CAOesGMjAb5oXjauhbqjDhJXWct7qoXxy3XpA1=DioK7vPTwetA@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
From: Olof Johansson <olof@lixom.net>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: Michal Simek <michal.simek@xilinx.com>,
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

Hi Andreas,

On Thu, Jul 24, 2014 at 4:00 PM, Andreas Färber <afaerber@suse.de> wrote:
> Hello,
>
> This patch series adds an initial device tree for the Parallella board.
> UART, SD card, Ethernet are enabled.
> Not yet enabled are HDMI, QSPI flash and 2x USB.

Andreas (Olofsson) kindly sent me a board, and I added it to the boot
farm today, it'll be included in boot reports from here on.

I did a test run with yesterday's -next It looks like networking isn't
working there at the moment, clock related. Same happens with 3.17 and
latest mainline, config multi_v7_defconfig:

[WARN] [    7.943648] macb e000b000.ethernet eth0: unable to generate
target frequency: 125000000 Hz
[WARN] [   10.948681] macb e000b000.ethernet eth0: unable to generate
target frequency: 125000000 Hz

Full boot log at:

http://arm-soc.lixom.net/bootlogs/misc/next-20141017/parallella-arm-multi_v7_defconfig.html

I'll be happy to try things, but I'm a bit short on cycles to debug
myself. Should hopefully be easy to reproduce.


-Olof
