Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab3JKQIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:08:31 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44302 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3JKQIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:08:30 -0400
MIME-Version: 1.0
In-Reply-To: <20131011153544.GA14715@kroah.com>
References: <1381460298-1097-1-git-send-email-ethan.kernel@gmail.com> <20131011153544.GA14715@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 11 Oct 2013 10:08:09 -0600
Message-ID: <CAErSpo7KHk66uxqerQfo60OLU=WVO6zMtfH24L8QPy9RcMHJ6g@mail.gmail.com>
Subject: Re: [PATCH] drivers/base/core.c: always output device renaming messages.
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "ethan.zhao" <ethan.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Don, e1000-devel]

On Fri, Oct 11, 2013 at 9:35 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Oct 11, 2013 at 10:58:18AM +0800, ethan.zhao wrote:
>> From: "ethan.zhao" <ethan.kernel@gmail.com>
>>
>> While loading ixgbevf driver,every vf detected will be output as the
>> same name 'eth4':
>>
>>  ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver -
>>  version 2.8.7
>>  Copyright (c) 2009-2012 Intel Corporation.
>>  ixgbevf 0000:20:10.0: enabling device (0000 -> 0002)
>>  ixgbe 0000:20:00.0 eth0: VF Reset msg received from vf 0
>>  ixgbevf 0000:20:10.0: irq 199 for MSI/MSI-X
>>  ixgbevf 0000:20:10.0: irq 200 for MSI/MSI-X
>>  ixgbevf: eth%d: ixgbevf_init_interrupt_scheme: Multiqueue Disabled: Rx Queue
>>  count = 1, Tx Queue count = 1
>
> What is that message?  That's not good, "eth%d"?

Just a reminder that ixgbevf 2.8.7 is not the driver version that's in
the kernel tree, so it's easy to spend time on mainline issue that
have been fixed in the out-of-tree versions, or vice versa.

Per Don, the latest ixgbevf driver is here:
https://sourceforge.net/projects/e1000/files/ixgbevf%20stable/

Bjorn
