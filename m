Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaIWPnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:43:31 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:55139 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaIWPna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:43:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140922203428.GF1880@google.com>
References: <1409001999-23161-1-git-send-email-minipli@googlemail.com>
	<20140922202748.GE1880@google.com>
	<20140922203428.GF1880@google.com>
Date: Tue, 23 Sep 2014 17:43:29 +0200
Message-ID: <CA+rthh-7onXuO=CVfRxfuUUThSFaAAWF0+gc0eSq3cZLDXyAAQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86/PCI: Minor size reduction by marking init code
 and data as such
From: Mathias Krause <minipli@googlemail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86-ml <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 September 2014 22:34, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc x86 folks]
>
> On Mon, Sep 22, 2014 at 02:27:48PM -0600, Bjorn Helgaas wrote:
>> On Mon, Aug 25, 2014 at 11:26:34PM +0200, Mathias Krause wrote:
>> > Hi Bjorn,
>> >
>> > [...]
>> >
>> > Mathias Krause (5):
>> >   x86/PCI: Mark DMI tables as initialization data
>> >   x86/PCI: Move __init annotation were it belongs to
>> >   x86/PCI: Mark constants of pci_mmcfg_nvidia_mcp55() as __initconst
>> >   x86/PCI: Constify pci_mmcfg_probes[] array
>> >   x86/PCI: Mark PCI BIOS initialization code as such
>>
>> All applied to pci/initdata for v3.18, thanks!
>
> Oops, I didn't notice that you hadn't cc'd the x86 folks.

The reason for me not cc'ing the x86 maintainers, but linux-pci
instead was probably because you're listed as maintainer for these
files in the MAINTAINERS file. But, true, x86 maintainers should be
cc'ed for all patches to code below arch/x86/. Just an oversight of
mine :/

>
> Guys, if these should go through -tip, here's my ack:
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>
> I don't have any other arch/x86 changes in my tree, so I don't care which
> way these go.


Regards,
Mathias
