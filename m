Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3BKGq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 01:46:58 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56407 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3BKGq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 01:46:57 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20130117165943.GI14149@atomide.com>
References: <1358422231-24736-2-git-send-email-rogerq@ti.com>
	<Pine.LNX.4.44L0.1301171016090.1339-100000@iolanthe.rowland.org>
	<20130117165943.GI14149@atomide.com>
Date: Sun, 10 Feb 2013 22:46:55 -0800
Message-ID: <CAOesGMhVeSPX2qWb+3Efo14Qbqmhrqpg1XRDnAfznHfAis-Fsg@mail.gmail.com>
Subject: Re: [PATCH v7 01/22] mfd: omap-usb-host: Consolidate OMAP USB-HS
 platform data
From: Olof Johansson <olof@lixom.net>
To: Tony Lindgren <tony@atomide.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roger Quadros <rogerq@ti.com>,
        balbi@ti.com, sameo@linux.intel.com, kishon@ti.com,
        sshtylyov@mvista.com, bjorn@mork.no, linux@arm.linux.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 8:59 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Alan Stern <stern@rowland.harvard.edu> [130117 07:19]:
>> On Thu, 17 Jan 2013, Roger Quadros wrote:
>>
>> > Let's have a single platform data structure for the OMAP's High-Speed
>> > USB host subsystem instead of having 3 separate ones i.e. one for
>> > board data, one for USB Host (UHH) module and one for USB-TLL module.
>> >
>> > This makes the code much simpler and avoids creating multiple copies of
>> > platform data.
>> >
>> > CC: Alan Stern <stern@rowland.harvard.edu>
>> >
>> > Signed-off-by: Roger Quadros <rogerq@ti.com>
>>
>> For the ehci-omap.c part:
>>
>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>
> If Samuel acks this patch, I can apply just this patch alone on v3.8-rc3
> into an immutable branch omap-for-v3.9/board-usb so we all merge it in
> as needed.

So, that didn't happen; Samuel applied it from the mailing list and
sfr just hit merge conflicts due to it.

Sigh.

This patch (touching arch/arm/mach-omap2) didn't have acks from Tony either.

Samuel, Tony, can you sort this out with a stable short topic branch
as Tony suggested? It'd be nice to avoid the merge conflict by a
little coordination here. :(


-Olof
