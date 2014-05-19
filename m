Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbaESTpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:45:17 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41038 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665AbaESTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:45:14 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1405191540040.1538-100000@iolanthe.rowland.org>
References: <1400526693-29776-5-git-send-email-ricardo.ribalda@gmail.com> <Pine.LNX.4.44L0.1405191540040.1538-100000@iolanthe.rowland.org>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 19 May 2014 21:44:53 +0200
Message-ID: <CAPybu_1=Q7YFQ=P2Qrzro-qKENdSemeAGyf-cmugqjx=F3LVHg@mail.gmail.com>
Subject: Re: [PATCH 4/5] usb: gadget: net2280: Code Cleanup
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Amit Uttamchandani <auttamchandani@logicube.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan


I am trying to be consistent around the file. On a previous patch I
was asked to move the operators at the end. I did so, and now I am
modifying the file to look alike.



On Mon, May 19, 2014 at 9:43 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:
>
>> Move logical continuations to end of line
>
> This is almost totally unnecessary.  Some people prefer the
> operators at the end of the first line, other people prefer them at the
> start of the next line.  It's just a matter of taste and it doesn't
> matter.
>
>> @@ -402,8 +402,8 @@ static void ep_reset_228x(struct net2280_regs __iomem *regs,
>>               BIT(DATA_PACKET_RECEIVED_INTERRUPT) |
>>               BIT(DATA_PACKET_TRANSMITTED_INTERRUPT) |
>>               BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
>> -             BIT(DATA_IN_TOKEN_INTERRUPT)
>> -             , &ep->regs->ep_stat);
>> +             BIT(DATA_IN_TOKEN_INTERRUPT),
>> +             &ep->regs->ep_stat);
>
> This is an example of the one type of change that does make sense.
> Nobody should start lines with a ','.
>
> Alan Stern
>



-- 
Ricardo Ribalda
