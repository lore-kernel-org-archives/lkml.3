Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbaF3TbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:31:12 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61272 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaF3TbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:31:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAPybu_29FPnRyJSJvnX+mosto+CF944PpREROeP282uqYb-FNw@mail.gmail.com>
References: <1400603412-19406-1-git-send-email-ricardo.ribalda@gmail.com> <CAPybu_29FPnRyJSJvnX+mosto+CF944PpREROeP282uqYb-FNw@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 30 Jun 2014 21:30:49 +0200
Message-ID: <CAPybu_3Mhho97gw+bN4ENnSGg37ajS7eEvNC3WbX+4PH6vUB5A@mail.gmail.com>
Subject: Re: [PATCH 00/10] net2280: Support for PLX USB338x and cleanout code
To: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Amit Uttamchandani <auttamchandani@logicube.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe

Any comment on this patchset? Shall I resend it rebased on v3.16-rc2?


Regards

On Tue, Jun 10, 2014 at 10:19 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Ping...
>
> On Tue, May 20, 2014 at 6:30 PM, Ricardo Ribalda Delgado
> <ricardo.ribalda@gmail.com> wrote:
>> The USB 3380 is a PCI Express Gen 2 to USB 3.0 SuperSpeed Peripheral
>> Controller. It shares a lot functionatily with the net228x family.
>>
>> This series of patches includes some resend of previous patches.
>>
>> Please check the changelog for every patch. This time it has been placed
>> under the tear line
>>
>>
>>
>> Ricardo Ribalda Delgado (10):
>>   usb: gadget: net2280: Add support for PLX USB338X
>>   usb: gadget: net2280: Dont use magic numbers
>>   usb: gadget: net2280: Use BIT() macro
>>   usb: gadget: net2280: Use true/false instead of 1/0
>>   usb: gadget: net2280: Use module_pci_driver macro
>>   usb: gadget: net2280: Refactor queues_show
>>   usb: gadget: net2280: Pass checkpacth.pl test
>>   usb: gadget: net2280: Code Cleanup
>>   usb: gadget: net2280: Use pr_* function
>>   usb: gadget: net2280: Use quirks instead of pci id
>>
>>  drivers/usb/gadget/Kconfig   |   10 +-
>>  drivers/usb/gadget/net2280.c | 2752 ++++++++++++++++++++++++++++--------------
>>  drivers/usb/gadget/net2280.h |  285 +++--
>>  include/linux/usb/usb338x.h  |  199 +++
>>  4 files changed, 2235 insertions(+), 1011 deletions(-)
>>  create mode 100644 include/linux/usb/usb338x.h
>>
>> --
>> 2.0.0.rc2
>>
>
>
>
> --
> Ricardo Ribalda



-- 
Ricardo Ribalda
