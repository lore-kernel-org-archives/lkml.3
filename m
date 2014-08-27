Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965070AbaH0VDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:03:22 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:53367 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935499AbaH0VDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:03:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140827202204.GA13047@kroah.com>
References: <1409144429-23723-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140827192547.GB9620@kroah.com> <CAPybu_1-pgEc5cwRPggm60UHKCceQZGAiyzjGqOhDZJedbkE8w@mail.gmail.com>
 <20140827202204.GA13047@kroah.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 27 Aug 2014 23:03:00 +0200
Message-ID: <CAPybu_1GRUTvatLeyst_M+0g0k8e=1z+F11eEyHkBonvYespCg@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: net2280: Remove pci_class from PCI_TABLE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg

>>
>> Not many drivers define the pci interface and there is no other driver
>> that has the same vendor  and product id. Therefore I see no hurt in
>> adding both patches, one to make the driver broader, and another to
>> fix pci-sysfs.
>>
>> Also, the change on pci-sysfs might affect more stuff and therefore
>> take longer to be applied.
>
> As we have been printing the value to userspace in this way for well
> over a decade now, and nothing has changed, I say it's a userspace bug
> that you should fix instead.  Don't work around broken user programs in
> the kernel by changing something that has been stable for 10+ years.
>
> Ok, sorry, not 10+ years, the commit was written May of 2005, so 9
> years.
>
> Fix your module loading code please.

On the other thread ( https://lkml.org/lkml/2014/8/27/242 ) we have
agreed about fixing this thing on pci-sysfs.c .

Still I think that there is no good reason to add the pci interface to
the pci_table on this driver. Therefore I consider that this patch is
still valid.

What do you think. This patch is NACK?


Thanks!

>
> thanks,
>
> greg k-h



-- 
Ricardo Ribalda
