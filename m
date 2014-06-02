Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaFBDwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 23:52:12 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:43949 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaFBDwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 23:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825E8405F@P3PWEX4MB008.ex4.secureserver.net>
References: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
	<1401425032-22721-1-git-send-email-chase.southwood@gmail.com>
	<DC148C5AA1CEBA4E87973D432B1C2D8825E8405F@P3PWEX4MB008.ex4.secureserver.net>
Date: Sun, 1 Jun 2014 22:52:09 -0500
Message-ID: <CA+jnaaXwukJ3vOukC54bJv3Br0sQG+NW405yjniRHu-t_a4X5Q@mail.gmail.com>
Subject: Re: [PATCH 6/6] staging: comedi: addi_apci_1564: cleanup v_ADDI_Interrupt()
From: Chase Southwood <chase.southwood@gmail.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 12:26 PM, Hartley Sweeten
<HartleyS@visionengravers.com> wrote:
> On Thursday, May 29, 2014 9:44 PM, Chase Southwood wrote:
>> Move the function apci1564_interrupt() from hwdrv_apci1564.c to
>> addi_apci_1564.c.  On moving, for now just strip out all of the
>> code for interrupts that the driver does not yet support at this
>> time.
>>
>> Rename the variable ui_InterruptStatus_1564 to ctrl, and change the return
>> from IRQ_RETVAL(1) to IRQ_HANDLED.
>>
>> We also check the device is asserting the shared interrupt line and check
>> that interrupts have been enabled.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
>> ---

Hartley,

Excellent...I will draft up a new version of this set based on all of
your comments, but I will hold off on sending until I see if Ian has
anything further to offer.  Things are certainly looking better
already though.

Thanks,
Chase
