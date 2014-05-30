Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbaE3OOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:14:07 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:43655 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaE3OOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140530095822.3588a6ff@Vantage>
References: <1395903457.5569.89.camel@pasglop> <20140530030618.5ad4f447@Vantage>
 <1401446278.14938.26.camel@pasglop> <20140530095822.3588a6ff@Vantage>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 30 May 2014 09:13:43 -0500
Message-ID: <CAAMCDecAgn=FX4Lw4YK_z4OKZsKqaj3scXe2cg0HN9tSj_FokA@mail.gmail.com>
Subject: Re: Bad DMA from Marvell 9230
To: =?ISO-8859-1?Q?J=E9r=F4me_Carretero?= <cJ-ko@zougloub.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a 9230...on older kernels it worked "ok" so long as you did not
do any smart commands, I removed it and went to something that works.
   Marvell appears to be hit and miss with some cards/chips working
right and some not...

Do enough smartcmds and the entire board (all 4 ports) locked up and
required a reboot, I quit doing smartcmds and stability went way up,
but it was still not 100% stable.

Supplier support "claimed" it to be a Linux AHCI bug as the "claim"
that their board correctly supports AHCI, even though all other AHCI
boards work right in this exact same use case in the exact same
machine.

On Fri, May 30, 2014 at 8:58 AM, Jérôme Carretero <cJ-ko@zougloub.eu> wrote:
> On Fri, 30 May 2014 20:37:58 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
>> We've switched to a 9235 instead which seems to work fine.
>
> Weird (I hadn't seen that you reported the 9235 working...), I have
> IOMMU problems with a 9235...
>
> What system are you running it on (when you say "power box", is it a
> beefy x86 computer or literally a PowerPC)?
> For me, AMD 990FX chipset, latest master linux.
> My board works fine* on another non-IOMMU system.
>
> --
> Jérôme
>
> * with issues with port multipliers
>
> Link to Benjamin's first message: https://lkml.org/lkml/2014/3/27/43
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
