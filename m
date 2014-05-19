Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaESTdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:33:33 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:40853 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaESTdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:33:31 -0400
MIME-Version: 1.0
In-Reply-To: <1400526979.14238.16.camel@joe-AO725>
References: <1400526693-29776-1-git-send-email-ricardo.ribalda@gmail.com>
 <1400526693-29776-6-git-send-email-ricardo.ribalda@gmail.com> <1400526979.14238.16.camel@joe-AO725>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 19 May 2014 21:33:10 +0200
Message-ID: <CAPybu_0T3GmyTQfPuG3YofkWO_px0fYAyofz2OAab6=9PqsKLQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] usb: gadget: net2280: Use pr_* function
To: Joe Perches <joe@perches.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Amit Uttamchandani <auttamchandani@logicube.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe

I think dev_vdg cannot be controlled with DYNAMIC_DEBUG, therefore I
replaced it with dev_dbg.

But if you prefer to use dev_dbg, I will modify it to use dev_dbg


Thanks!

On Mon, May 19, 2014 at 9:16 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2014-05-19 at 21:11 +0200, Ricardo Ribalda Delgado wrote:
>> VDEBUG has also been replaced by DEBUG because the same       functionality
>> (or even better) can be achieved with dynamic printk.
>
> dev_vdbg exists for that purpose.
>
>



-- 
Ricardo Ribalda
