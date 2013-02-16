Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3BPD4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 22:56:11 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51169 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3BPD4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 22:56:09 -0500
MIME-Version: 1.0
In-Reply-To: <1360684037.12703.117.camel@sauron.fi.intel.com>
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>
	<1359349039-11510-2-git-send-email-b32955@freescale.com>
	<1360684037.12703.117.camel@sauron.fi.intel.com>
Date: Sat, 16 Feb 2013 11:56:09 +0800
Message-ID: <CAMiH66ExMK8rPMw3kvs9M2b-0ZSkfxBYteTi8QTZf+XCzJw5Dw@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] mtd: add new fields to nand_flash_dev{}
From: Huang Shijie <shijie8@gmail.com>
To: dedekind1@gmail.com
Cc: Huang Shijie <b32955@freescale.com>, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 11:47 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Mon, 2013-01-28 at 12:57 +0800, Huang Shijie wrote:
>> +       {"SmartMedia 256MiB 3,3V",      {0, 0x71}, 512, 256, 0x4000 },
>> +       {"SmartMedia 256MiB 3,3V ROM",  {0, 0x5b}, 512, 256, 0x4000,
>> NAND_ROM},
>
> Sorry for a possibly stupid question, but what does it buy you adding
> another "0" to all the entries? I see you add another table, which you
> look up if the "traditional" table does not work. Why you need to add
> these zeroes?

The zeros are for the maf_id.

The dev_id is the second byte of the 8-byte id data.

thanks
Huang Shijie


>
> --
> Best Regards,
> Artem Bityutskiy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
