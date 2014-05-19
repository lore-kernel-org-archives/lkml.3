Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaESKZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:25:19 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:61861 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaESKZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:25:16 -0400
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1724900B@AcuExch.aculab.com>
References: <1400494205-26566-1-git-send-email-ricardo.ribalda@gmail.com>
 <1400494205-26566-3-git-send-email-ricardo.ribalda@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D1724900B@AcuExch.aculab.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 19 May 2014 12:24:56 +0200
Message-ID: <CAPybu_2uTM6TB9756SHeWs424L6ERtgbk+Ea_U+VXCcaooS7dg@mail.gmail.com>
Subject: Re: [PATCH 3/5] usb: gadget: net2280: Use BIT() macro
To: David Laight <David.Laight@aculab.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "auttamchandani@logicube.com" <auttamchandani@logicube.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David

I dont want to start a flame war here :) but  In the particular case
of hardware registers I believe it does.

This patch has been posted because on a previous patch to support the
usb3380, one of the requested changes was to use this macro. In order
to have consistent code in the file I have posted this patch.

BTW, I havent defined the bit macro, just used it :P

Cheers!


On Mon, May 19, 2014 at 12:18 PM, David Laight <David.Laight@aculab.com> wrote:
> From: Ricardo Ribalda Delgado
>> Improves readability of the code
>
> Personally I don't find macros like BIT() improve the readability at all.
> What next? Maybe:
>
> #define ADD(a, b) ((a) + (b))
>
>         David
>
>
>



-- 
Ricardo Ribalda
