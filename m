Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab3CUPuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:50:50 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:54763 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3CUPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:50:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAJtEV7YDNGq-t1W2Q4=mBobKGATz14hqkamauL=5KqZ728U9wg@mail.gmail.com>
References: <1362666523-9961-1-git-send-email-yxlraid@gmail.com>
	<CAErSpo69g-dJo4xW+bvGuz=TALfMLQBgQ-_PLvsa-c58AzOVJA@mail.gmail.com>
	<CAJtEV7YDNGq-t1W2Q4=mBobKGATz14hqkamauL=5KqZ728U9wg@mail.gmail.com>
Date: Thu, 21 Mar 2013 09:50:47 -0600
Message-ID: <CAL-B5D38sNcvpR+XxjLLbAm279v5LuCGQttai-Ek6zOUWCbv3g@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: define macro for marvell vendor ID
From: Myron Stowe <myron.stowe@gmail.com>
To: Andrew Cooks <acooks@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, yxlraid@gmail.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiangliang Yu <yuxiangl@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:23 PM, Andrew Cooks <acooks@gmail.com> wrote:
> On Fri, Mar 8, 2013 at 12:24 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Thu, Mar 7, 2013 at 7:28 AM,  <yxlraid@gmail.com> wrote:
>>> From: Xiangliang Yu <yuxiangl@marvell.com>
>>>
>>> Define PCI_VENDOR_MARVELL_ID_EXT macro for 0x1b4b vendor ID
>>
>> "PCI_VENDOR_MARVELL_ID_EXT" is not actually the symbol you defined below.
>>
>> Per the comment at the top of pci_ids.h, we don't add things here
>> unless they are shared between multiple drivers.
>>
>> That said, the 0x1b4b vendor ID is used in mv_init.c, mvumi.h,
>> mvumi.c, and ahci.c.  If you want to unify all those so they all use
>> same symbol, and define that symbol here in pci_ids.h, that would be
>> fine with me.
>>
>
> This symbol will also be useful for the quirk that creates iommu
> context entries for Marvell devices that use incorrect dma source
> tags. I'll update and resend that patch when this change has been
> merged.

Andrew -
  A new series that includes the 0x1b4b vendor ID change was posted
last night so you may want to follow that:
https://lkml.org/lkml/2013/3/21/12

>
> Thanks
> Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
