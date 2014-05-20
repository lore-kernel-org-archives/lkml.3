Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaETI4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:56:07 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:44355 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaETI4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:56:04 -0400
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17249DE6@AcuExch.aculab.com>
References: <1400526693-29776-4-git-send-email-ricardo.ribalda@gmail.com>
 <Pine.LNX.4.44L0.1405191531010.1538-100000@iolanthe.rowland.org> <063D6719AE5E284EB5DD2968C1650D6D17249DE6@AcuExch.aculab.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 20 May 2014 10:55:43 +0200
Message-ID: <CAPybu_1FnfFKT-X-VNP+HgAKjitJSVy0O2GY5uY+icS8RwfrcA@mail.gmail.com>
Subject: Re: [PATCH 3/5] usb: gadget: net2280: Pass checkpacth.pl test
To: David Laight <David.Laight@aculab.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "auttamchandani@logicube.com" <auttamchandani@logicube.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not for grep...

But if this is an issue I have no problem going back to the original.
We can spend a whole year just talking about codestyle.



On Tue, May 20, 2014 at 10:52 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Alan Stern
> ...
>> > -static struct usb_request *
>> > -net2280_alloc_request (struct usb_ep *_ep, gfp_t gfp_flags)
>> > +static struct usb_request *net2280_alloc_request(struct usb_ep *_ep,
>> > +                                                   gfp_t gfp_flags)
>>
>> What's with the extreme indentation on the continuation line?  The
>> style used here is for continuation lines to be indented by two stops
>> relative to the first line.
>
> Also why move the line break?
> The Linux kernel has both styles, and the original one (with the
> function name starting in column 1) makes it much easier to search
> to the definition.
>
>         David
>
>
>



-- 
Ricardo Ribalda
