Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaBEJZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:25:35 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:36387 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaBEJZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:25:32 -0500
Message-ID: <52F20388.9080109@codethink.co.uk>
Date: Wed, 05 Feb 2014 09:25:28 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-pci@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 00/04] PCI: rcar: Driver model and physical address space
 update
References: <20140205065243.29445.76593.sendpatchset@w520> <52F1F74C.2090106@codethink.co.uk> <CANqRtoRMAjBEXjBzivPxqMu8KhFsOkp0wb6jBbuZQx=B-qYuUA@mail.gmail.com>
In-Reply-To: <CANqRtoRMAjBEXjBzivPxqMu8KhFsOkp0wb6jBbuZQx=B-qYuUA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 09:00, Magnus Damm wrote:
> Hi Ben,

[snip]
> I think we should try to pick out the stuff that is ready to be merged
> first. I think these patches may require a bit of time before people
> start looking at them. I don't mind resending in the future.
>
> To be honest, I have not been paying too much attention to other
> patches including yours - been focused trying to get the memory
> management part right.. So I'd like to focus on correctness over DT
> for now if possible. Of course we it all.
>
> Would it be possible for you to provide a list of pci-rcar-gen2.c
> patches that you posted? Or perhaps you can resend your series and
> include acks that you received?

I don't think I have any acks, only review comments. I think the code
itself is pretty much ready to be merged and has been tested here with
the Lager board.

The big issue for us is that we /must/ boot with fdt, which means the
less fdt support that is in the kernel then the more patches we end up
carrying out of tree. This is why we have been pushing patches out to
try and get the support in.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
