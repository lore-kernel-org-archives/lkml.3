Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3CLFXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:23:07 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64981 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3CLFXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:23:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo69g-dJo4xW+bvGuz=TALfMLQBgQ-_PLvsa-c58AzOVJA@mail.gmail.com>
References: <1362666523-9961-1-git-send-email-yxlraid@gmail.com>
	<CAErSpo69g-dJo4xW+bvGuz=TALfMLQBgQ-_PLvsa-c58AzOVJA@mail.gmail.com>
Date: Tue, 12 Mar 2013 13:23:02 +0800
Message-ID: <CAJtEV7YDNGq-t1W2Q4=mBobKGATz14hqkamauL=5KqZ728U9wg@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: define macro for marvell vendor ID
From: Andrew Cooks <acooks@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: yxlraid@gmail.com, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiangliang Yu <yuxiangl@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 12:24 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Mar 7, 2013 at 7:28 AM,  <yxlraid@gmail.com> wrote:
>> From: Xiangliang Yu <yuxiangl@marvell.com>
>>
>> Define PCI_VENDOR_MARVELL_ID_EXT macro for 0x1b4b vendor ID
>
> "PCI_VENDOR_MARVELL_ID_EXT" is not actually the symbol you defined below.
>
> Per the comment at the top of pci_ids.h, we don't add things here
> unless they are shared between multiple drivers.
>
> That said, the 0x1b4b vendor ID is used in mv_init.c, mvumi.h,
> mvumi.c, and ahci.c.  If you want to unify all those so they all use
> same symbol, and define that symbol here in pci_ids.h, that would be
> fine with me.
>

This symbol will also be useful for the quirk that creates iommu
context entries for Marvell devices that use incorrect dma source
tags. I'll update and resend that patch when this change has been
merged.

Thanks
Andrew
