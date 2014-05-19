Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaESTgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:36:21 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:44063 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaESTgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:36:19 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1405191527520.1538-100000@iolanthe.rowland.org>
References: <1400526693-29776-3-git-send-email-ricardo.ribalda@gmail.com> <Pine.LNX.4.44L0.1405191527520.1538-100000@iolanthe.rowland.org>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 19 May 2014 21:35:59 +0200
Message-ID: <CAPybu_3hnb+_V5kkzxaYFtc4GeKCs84VzPRVbAhJbfqO57tcsA@mail.gmail.com>
Subject: Re: [PATCH 2/5] usb: gadget: net2280: Use S_I macros
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

What about using octal notation in all the file and merge the patch
with the other big patch of the series? I am trying to have some
consistency in the file :)


Thanks!

On Mon, May 19, 2014 at 9:30 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:
>
>> Instead of octal notation, to be consistent around the file.
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>  drivers/usb/gadget/net2280.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
>> index c3205ec..5b2ab68 100644
>> --- a/drivers/usb/gadget/net2280.c
>> +++ b/drivers/usb/gadget/net2280.c
>> @@ -111,7 +111,7 @@ module_param(use_msi, bool, S_IRUGO);
>>  static ushort fifo_mode = 0;
>>
>>  /* "modprobe net2280 fifo_mode=1" etc */
>> -module_param (fifo_mode, ushort, 0644);
>> +module_param(fifo_mode, ushort, S_IRUGO | S_IWUSR);
>
> I don't think this is necessary, in and of itself.  In my opinion, the
> macros are a lot harder to figure out than the octal values.
>
> Don't bother making this change.  It's useless churn.
>
> Alan Stern
>



-- 
Ricardo Ribalda
