Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaATH1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 02:27:42 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:38000 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaATH1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 02:27:40 -0500
MIME-Version: 1.0
In-Reply-To: <52D94006.2090104@balister.org>
References: <1389894803-4147-1-git-send-email-sthokal@xilinx.com>
	<1389894803-4147-2-git-send-email-sthokal@xilinx.com>
	<52D94006.2090104@balister.org>
Date: Mon, 20 Jan 2014 12:57:39 +0530
Message-ID: <CA+mB=1J8hoTnVuN0DaC1kXH7mWe5Ydw8o12wuBj+MyWVAVuJfw@mail.gmail.com>
Subject: Re: [PATCH] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
From: Srikanth Thokala <sriku.linux@gmail.com>
To: Philip Balister <philip@balister.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philip,

On Fri, Jan 17, 2014 at 8:06 PM, Philip Balister <philip@balister.org> wrote:
> On 01/16/2014 12:53 PM, Srikanth Thokala wrote:
>>
>> This is the driver for the AXI Video Direct Memory Access (AXI
>> VDMA) core, which is a soft Xilinx IP core that provides high-
>> bandwidth direct memory access between memory and AXI4-Stream
>> type video target peripherals. The core provides efficient two
>> dimensional DMA operations with independent asynchronous read
>> and write channel operation.
>>
>
> [snip]
>
>
>> +/**
>> + * xilinx_vdma_start - Start VDMA channel
>> + * @chan: Driver specific VDMA channel
>> + */
>> +static void xilinx_vdma_start(struct xilinx_vdma_chan *chan)
>> +{
>> +       int loop = XILINX_VDMA_LOOP_COUNT + 1;
>> +
>> +       vdma_ctrl_set(chan, XILINX_VDMA_REG_DMACR,
>> XILINX_VDMA_DMACR_RUNSTOP);
>> +
>> +       /* Wait for the hardware to start */
>> +       while (loop)
>
>
>
> loop-- ?

I will fix it in v2.

Thanks
Srikanth
