Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaBEJkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:40:08 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:37502 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaBEJkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:40:03 -0500
MIME-Version: 1.0
In-Reply-To: <52F20388.9080109@codethink.co.uk>
References: <20140205065243.29445.76593.sendpatchset@w520>
	<52F1F74C.2090106@codethink.co.uk>
	<CANqRtoRMAjBEXjBzivPxqMu8KhFsOkp0wb6jBbuZQx=B-qYuUA@mail.gmail.com>
	<52F20388.9080109@codethink.co.uk>
Date: Wed, 5 Feb 2014 18:40:00 +0900
Message-ID: <CANqRtoRUWC5ioDXJdEM6utQo2uHB3xar3RHzapR--xhjRmRQag@mail.gmail.com>
Subject: Re: [PATCH 00/04] PCI: rcar: Driver model and physical address space update
From: Magnus Damm <magnus.damm@gmail.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-pci@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 6:25 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> On 05/02/14 09:00, Magnus Damm wrote:
>>
>> Hi Ben,
>
>
> [snip]
>
>> I think we should try to pick out the stuff that is ready to be merged
>> first. I think these patches may require a bit of time before people
>> start looking at them. I don't mind resending in the future.
>>
>> To be honest, I have not been paying too much attention to other
>> patches including yours - been focused trying to get the memory
>> management part right.. So I'd like to focus on correctness over DT
>> for now if possible. Of course we it all.
>>
>> Would it be possible for you to provide a list of pci-rcar-gen2.c
>> patches that you posted? Or perhaps you can resend your series and
>> include acks that you received?
>
>
> I don't think I have any acks, only review comments. I think the code
> itself is pretty much ready to be merged and has been tested here with
> the Lager board.

Ok, thanks. I'd like to go through them myself if possible. I was
looking for a cover letter or something that listed the patches but I
can't seem to find it. Can you please provide a list?

> The big issue for us is that we /must/ boot with fdt, which means the
> less fdt support that is in the kernel then the more patches we end up
> carrying out of tree. This is why we have been pushing patches out to
> try and get the support in.

Can you please define "boot with fdt"? As you probably know, both
board-lager.c and board-lager-reference.c boot with DT. I suppose you
mean that you want DT to describe the entire system, with no C code
for the board? Please note that some devices like timers still don't
use DT, so if you can live without those then... =)

Thanks,

/ magnus
