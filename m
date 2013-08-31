Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3HaAJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:09:23 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62890 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3HaAJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:09:22 -0400
Message-ID: <52213433.5070603@cogentembedded.com>
Date: Sat, 31 Aug 2013 04:09:23 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: vinod.koul@intel.com
CC: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        max.filippov@cogentembedded.com
Subject: Re: [PATCH v3] dma: add driver for R-Car HPB-DMAC
References: <201308250033.24936.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201308250033.24936.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/25/2013 12:33 AM, Sergei Shtylyov wrote:

> From: Max Filippov <max.filippov@cogentembedded.com>

> Add support for HPB-DMAC found in Renesas R-Car SoCs, using 'shdma-base' DMA
> driver framework.

> Based on the original patch by Phil Edworthy <phil.edworthy@renesas.com>.

> Signed-off-by: Max Filippov <max.filippov@cogentembedded.com>
> [Sergei: removed useless #include, sorted #include's, fixed HPB_DMA_TCR_MAX,
> fixed formats and removed line breaks in the dev_dbg() calls, rephrased and
> added IRQ # to the shdma_request_irq() failure message, added MODULE_AUTHOR(),
> removed '__init'/'__exit' annotations from the probe()/remove() methods, removed
> '__initdata' annotation from 'hpb_dmae_driver', fixed guard macro name in the
> header file, fixed #define ASYNCRSTR_ASRST20, added #define ASYNCRSTR_ASRST24,
> added the necessary runtime PM calls to the probe() and remove() methods,
> handled errors returned by dma_async_device_register(), beautified comments
> and #define's.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

    Vinod, we've posted the updated patch almost a week ago. Is there any hope 
to get it into 3.12?

WBR, Sergei

