Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3BKH7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 02:59:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52574 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab3BKH7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 02:59:20 -0500
Message-ID: <5118A4BC.2020003@ti.com>
Date: Mon, 11 Feb 2013 09:58:52 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Tony Lindgren <tony@atomide.com>, Alan Stern <stern@rowland.harvard.edu>,
        <balbi@ti.com>, <sameo@linux.intel.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/22] mfd: omap-usb-host: Consolidate OMAP USB-HS
 platform data
References: <1358422231-24736-2-git-send-email-rogerq@ti.com> <Pine.LNX.4.44L0.1301171016090.1339-100000@iolanthe.rowland.org> <20130117165943.GI14149@atomide.com> <CAOesGMhVeSPX2qWb+3Efo14Qbqmhrqpg1XRDnAfznHfAis-Fsg@mail.gmail.com>
In-Reply-To: <CAOesGMhVeSPX2qWb+3Efo14Qbqmhrqpg1XRDnAfznHfAis-Fsg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 08:46 AM, Olof Johansson wrote:
> On Thu, Jan 17, 2013 at 8:59 AM, Tony Lindgren <tony@atomide.com> wrote:
>> * Alan Stern <stern@rowland.harvard.edu> [130117 07:19]:
>>> On Thu, 17 Jan 2013, Roger Quadros wrote:
>>>
>>>> Let's have a single platform data structure for the OMAP's High-Speed
>>>> USB host subsystem instead of having 3 separate ones i.e. one for
>>>> board data, one for USB Host (UHH) module and one for USB-TLL module.
>>>>
>>>> This makes the code much simpler and avoids creating multiple copies of
>>>> platform data.
>>>>
>>>> CC: Alan Stern <stern@rowland.harvard.edu>
>>>>
>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>
>>> For the ehci-omap.c part:
>>>
>>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>>
>> If Samuel acks this patch, I can apply just this patch alone on v3.8-rc3
>> into an immutable branch omap-for-v3.9/board-usb so we all merge it in
>> as needed.
> 
> So, that didn't happen; Samuel applied it from the mailing list and
> sfr just hit merge conflicts due to it.
> 
> Sigh.
> 
> This patch (touching arch/arm/mach-omap2) didn't have acks from Tony either.

Oops, this is my bad :(. Should have flagged Samuel about it. Will be more careful
next time.

> 
> Samuel, Tony, can you sort this out with a stable short topic branch
> as Tony suggested? It'd be nice to avoid the merge conflict by a
> little coordination here. :(
> 
>

cheers,
-roger

