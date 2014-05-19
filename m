Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaESV2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:28:40 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35147 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaESV2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <1400534436-10913-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400534436-10913-1-git-send-email-ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 19 May 2014 23:28:17 +0200
Message-ID: <CAPybu_2yQ0OzHth31L9oeWQ1nxFZAsbTq_i5=f_gV3E9=ygeLg@mail.gmail.com>
Subject: Re: [PATCH 0/9] net2280: Support for PLX USB338x and cleanout code
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

Hello

I have just realized that I havent moved the changleg information
under the tear line. I will resend the patchset with this fixed once I
have received comments about this patchset.

Sorry and thanks for your patience.



On Mon, May 19, 2014 at 11:20 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> The USB 3380 is a PCI Express Gen 2 to USB 3.0 SuperSpeed Peripheral
> Controller. It shares a lot functionatily with the net228x family.
>
> This series of patches includes some resend of previous patches.
>
> Please check the changelog for every patch.
>
> Ricardo Ribalda Delgado (9):
>   usb: gadget: net2280: Add support for PLX USB338X
>   usb: gadget: net2280: Dont use magic numbers
>   usb: gadget: net2280: Use BIT() macro
>   usb: gadget: net2280: Use true/false instead of 1/0
>   usb: gadget: net2280: Use module_pci_driver macro
>   usb: gadget: net2280: Refactor queues_show
>   usb: gadget: net2280: Pass checkpacth.pl test
>   usb: gadget: net2280: Code Cleanup
>   usb: gadget: net2280: Use pr_* function
>
>  drivers/usb/gadget/Kconfig   |   10 +-
>  drivers/usb/gadget/net2280.c | 2746 ++++++++++++++++++++++++++++--------------
>  drivers/usb/gadget/net2280.h |  281 +++--
>  include/linux/usb/usb338x.h  |  199 +++
>  4 files changed, 2225 insertions(+), 1011 deletions(-)
>  create mode 100644 include/linux/usb/usb338x.h
>
> --
> 2.0.0.rc2
>



-- 
Ricardo Ribalda
