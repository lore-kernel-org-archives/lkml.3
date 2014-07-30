Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaG3LYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:24:55 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36992 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaG3LYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <8258903.Rn4s07GKGV@wuerfel>
References: <1406131381-25577-1-git-send-email-sthokal@xilinx.com>
	<CA+mB=1JhDF=BBXcyTbgVB8S7qH=Mb1JH78HLL4pA9OBH19hQvA@mail.gmail.com>
	<8258903.Rn4s07GKGV@wuerfel>
Date: Wed, 30 Jul 2014 16:54:49 +0530
X-Google-Sender-Auth: uBzboMwjuleXLbfQXBst2-lwqcU
Message-ID: <CA+mB=1LeZn1k2VHNby2TRBcb1xuFFTQio=C845_xe2A=ZciYqg@mail.gmail.com>
Subject: Re: [PATCH v5] pcie: Add Xilinx PCIe Host Bridge IP driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        svemula@xilinx.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>, anirudh@xilinx.com,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Jul 28, 2014 at 6:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 28 July 2014 18:04:34 Srikanth Thokala wrote:
>> Hi Arnd and Rob,
>>
>> I discussed with Bjorn and we believe this patch is in good shape to
>> apply.  And Bjorn requires ACKs to apply this patch.  So, could you
>> guys please review this patch and provided your ACKs to this patch.
>
> Looks great for the most part. I've looked through the whole driver
> again, and I have two small issues remaining:
>
> a) Please clarify in the changeset description why there is no support
>    for PCI I/O space.

Sure, I will add to my changeset.

>
> b) I think you should use the 'msi-parent' property, and the
>    of_pci_find_msi_chip_by_node() to find the msi_chip for the
>    PCI controller. This will make it possible to forward MSIs
>    to the main interrupt controller in the system, which is more
>    efficient. See the pcie-mvebu driver for an example of this.

Ok, I need to look into this and I will plan to implement on top of this patch.

>
> Other than these:
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks Arnd for the Ack.

Srikanth

>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
