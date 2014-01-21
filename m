Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaAUKVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:21:20 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:36353 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbaAUKVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:21:17 -0500
MIME-Version: 1.0
In-Reply-To: <1389972737.7619.14.camel@smile>
References: <1389894803-4147-1-git-send-email-sthokal@xilinx.com>
	<1389972737.7619.14.camel@smile>
Date: Tue, 21 Jan 2014 15:51:15 +0530
X-Google-Sender-Auth: SAUzewmZUA-lT0n_z36U1LlRfMM
Message-ID: <CA+mB=1Lb9cXUwxKG5ZqmDVtFgMgyGBP+G6mugxU-zjFs87_pew@mail.gmail.com>
Subject: Re: [PATCH] Add Xilinx AXI Video DMA Engine driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>, dan.j.williams@intel.com,
        vinod.koul@intel.com, michal.simek@xilinx.com,
        Grant Likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Fri, Jan 17, 2014 at 9:02 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Thu, 2014-01-16 at 23:23 +0530, Srikanth Thokala wrote:
>> Hi,
>>
>> This is the driver for Xilinx AXI Video Direct Memory Access Engine.
>> It is a soft IP core, which provides high-bandwidth direct memory
>> access between memory and AXI4-Stream video type target peripherals
>> including peripherals which support AXI4-Stream Video Protocol. The
>> core provides efficient two dimensional DMA operations with independent
>> asynchronous read and write channel operation.
>>
>> For more information on the IP, please refer to
>> http://www.xilinx.com/support/documentation/ip_documentation/axi_vdma/v6_1/pg020_axi_vdma.pdf
>>
>> This patch also provides a test client, which assumes read and write channels
>> of the core are configured in a back-to-back connection.  It transfers
>> data on the write channel, read and verify the data on the read channel.
>>
>>  drivers/dma/xilinx/xilinx_vdma_test.c              |  629 ++++++++
>
> What about to modify dmatest.c accordingly to your needs?
> I see no much sense to have another copy of that in the tree.

I agree with you, we thought it will be good to provide a simple test
case for our driver,
I will drop off this test client from my v2 patch set.

Thanks
Srikanth

>
> --
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
