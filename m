Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaADAaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:30:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35336 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaADAaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:30:10 -0500
Date: Fri, 03 Jan 2014 19:30:08 -0500 (EST)
Message-Id: <20140103.193008.684316024702680161.davem@davemloft.net>
To: bhelgaas@google.com
Cc: jesse.brandeburg@gmail.com, linux-pci@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org, gospo@redhat.com,
        sassmann@redhat.com, linux-kernel@vger.kernel.org,
        bjorn.helgaas@hp.com
Subject: Re: [net-next] pci_regs.h: Add PCI bus link speed and width defines
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAErSpo7TJXTCxpFKWXLTaHmqXXnYQdnpNeWt+cehSaES2Jh30w@mail.gmail.com>
References: <CAErSpo7K3OBuTEZrXmhQ3iXtLf3M5JNnEqmAvaceroJ46VAOKg@mail.gmail.com>
	<20140103.185607.1380379872647540168.davem@davemloft.net>
	<CAErSpo7TJXTCxpFKWXLTaHmqXXnYQdnpNeWt+cehSaES2Jh30w@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 03 Jan 2014 16:30:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 3 Jan 2014 17:00:42 -0700

> On Fri, Jan 3, 2014 at 4:56 PM, David Miller <davem@davemloft.net> wrote:
>> From: Bjorn Helgaas <bhelgaas@google.com>
>> Date: Fri, 3 Jan 2014 15:15:57 -0700
>>
>>> However, I do raise my eyebrows a bit at drivers that poke around in
>>> the PCIe capability.  I would prefer to have PCI core interfaces that
>>> handle that instead.  But I haven't seen Jeff's changes yet.
>>
>> The changes just read the link status to interpret the speed at which
>> the PCI-E link is running at.
> 
> Several drivers want to do that.  It'd be nice if somebody abstracted
> that out somehow.  Jacob added pcie_get_minimum_link() which is
> similar.  But maybe Jeff needs something more in this case.
> 
> In any case, it's not a blocker for this patch.

Ok.

Jeff, please merge this via the Intel submission process and don't forget
to add Bjorn's ACK.

Thanks.
