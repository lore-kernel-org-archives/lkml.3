Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaAFJSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:18:08 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:65212 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaAFJSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:18:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140106090933.GM30234@mwanda>
References: <1388998839-28799-1-git-send-email-aruna.hewapathirane@gmail.com>
	<20140106090933.GM30234@mwanda>
Date: Mon, 6 Jan 2014 04:18:05 -0500
Message-ID: <CAFSeFg8ajJP9oxBxdBSPxx0wEdhrE1N=1viNPu5cLC1FdHjtLA@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: fixed style issue Fixed a coding style
 issue Signed-off-by: Aruna Hewapathirane <aruna.hewapathirane@gmail.com>
From: Aruna Hewapathirane <aruna.hewapathirane@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: abbotti@mev.co.uk, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

my apologies, it's my very first patch :-)

On Mon, Jan 6, 2014 at 4:09 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Changelog mangled.  You need a blank after the subject.
>
> On Mon, Jan 06, 2014 at 04:00:39AM -0500, Aruna-Hewapathirane wrote:
>> ---
>>  drivers/staging/comedi/drivers/ke_counter.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
>> index 15589f6..cebf818 100644
>> --- a/drivers/staging/comedi/drivers/ke_counter.c
>> +++ b/drivers/staging/comedi/drivers/ke_counter.c
>> @@ -105,7 +105,7 @@ static int cnt_auto_attach(struct comedi_device *dev,
>>       dev->read_subdev = s;
>>       s->type = COMEDI_SUBD_COUNTER;
>> -     s->subdev_flags = SDF_READABLE /* | SDF_COMMON */ ;
>> +     s->subdev_flags = SDF_READABLE /* | SDF_COMMON */;
>>       s->n_chan = 3;
>>       s->maxdata = 0x00ffffff;
>>       s->insn_read = cnt_rinsn;
>> @@ -120,7 +120,7 @@ static int cnt_auto_attach(struct comedi_device *dev,
>>       outb(0, dev->iobase + 0x40);
>>       dev_info(dev->class_dev, "%s: %s attached\n",
>> -             dev->driver->driver_name, dev->board_name);
>> +     dev->driver->driver_name, dev->board_name);
>
> Nope.  The original was better.
>
> regards,
> dan carpenter
>
>>       return 0;
>>  }
>> --
>> 1.7.0.4
>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel



-- 
Aruna Hewapathirane
Consultant/Trainer
Phone : 647-709-9269
Website: Open Source Solutions
