Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3JIROs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:14:48 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:61279 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3JIROq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:14:46 -0400
Message-ID: <52559CCC.4040809@cogentembedded.com>
Date: Wed, 09 Oct 2013 20:13:32 +0200
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: vinod.koul@intel.com
CC: Simon Horman <horms@verge.net.au>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] rcar-hpbdma: remove shdma_free_irq() calls
References: <201309260228.37765.sergei.shtylyov@cogentembedded.com> <20130926021417.GC18396@verge.net.au> <20131003040031.GA7925@verge.net.au>
In-Reply-To: <20131003040031.GA7925@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-10-2013 6:00, Simon Horman wrote:

>>> Commit c1c63a14f4f2419d093acd7164eccdff315baa86 (DMA: shdma: switch to managed
>>> resource allocation) got rid of shdma_free_irq() but  unfortunately got merged
>>> later than commit c4f6c41ba790bbbfcebb4c47a709ac8ff1fe1af9 (dma: add driver for
>>> R-Car HPB-DMAC), so that the HPB-DMAC driver retained the calls and got broken:

>>> drivers/dma/sh/rcar-hpbdma.c: In function `hpb_dmae_alloc_chan_resources':
>>> drivers/dma/sh/rcar-hpbdma.c:435: error: implicit declaration of function
>>> `shdma_free_irq'

>>> Fix this compilation error by removing the remaining shdma_free_irq() calls.

>> Tested-by: Simon Horman <horms+renesas@verge.net.au>

>>> Reported-by: Simon Horman <horms@verge.net.au>
>>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

> Vinod, could you consider taking this and the following patch
> as a fix for v3.12?

    Vinod, may I ask when these regression (induced by you) fixes gets merged?

WBR, Sergei

