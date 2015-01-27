Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbbA0Dng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:43:36 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42391 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbA0Dnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:43:33 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBb+bWiX2eayjBQHsvCjTp3t8H9=AviF9AkV6CC--cC_fYQ@mail.gmail.com>
References: <20150123203145.GA6691@google.com>
	<CA+8MBbKnT=mE3kev8BRPq0GeTgHx8WVa6o54tJuBX_XXLpHdYQ@mail.gmail.com>
	<CAErSpo7y1wWStjcEOH9xTiM-As8+QeMynZ5ENrL9v3X2PvQCcw@mail.gmail.com>
	<CA+8MBb+bWiX2eayjBQHsvCjTp3t8H9=AviF9AkV6CC--cC_fYQ@mail.gmail.com>
Date: Mon, 26 Jan 2015 19:43:32 -0800
X-Google-Sender-Auth: ICTGnCF7mbvwasbYyfsiPZ1Ad58
Message-ID: <CAE9FiQXj07CtOJ6uBZomNyhAH9ANanbbUSo51td6G-UB5Rmmow@mail.gmail.com>
Subject: Re: [GIT PULL] PCI fixes for v3.19
From: Yinghai Lu <yinghai@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Richard Zhu <Richard.Zhu@freescale.com>,
        Marek Kordik <kordikmarek@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andreas Hartmann <andihartmann@freenet.de>,
        Alexey Voronkov <zermond@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 1:24 PM, Tony Luck <tony.luck@gmail.com> wrote:
> On Mon, Jan 26, 2015 at 1:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> Sorry for the inconvenience.  Can you collect a complete dmesg log and
>> "lspci -vv" output, too (from the kernel with the reverted commit)?
>> That will have more useful information than just /proc/iomem.
>
> Full dmesg, lspci -vv, and bonus .config (CONFIG_PCI_IOV is indeed
> not set)

Sorry for the problem.

Can you please get boot bog with "debug ignore_logleve"?

we should get print out from

+               dev_printk(KERN_DEBUG, &dev->dev, "%pR clipped to %pR\n",
+                                &orig_res, res);


Thanks

Yinghai
