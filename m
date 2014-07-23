Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbaGWHpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:45:23 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:55623 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbaGWHpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:45:18 -0400
Message-ID: <53CF6808.4070206@atmel.com>
Date: Wed, 23 Jul 2014 09:45:12 +0200
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>, <soren.brinkmann@xilinx.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] net/macb: add scatter-gather hw feature
References: <cover.1405689937.git.cyrille.pitchen@atmel.com>	<fda3a504240e1f6863107ef6bf1e78586671a030.1405689937.git.cyrille.pitchen@atmel.com> <20140720.211337.211665722122921773.davem@davemloft.net>
In-Reply-To: <20140720.211337.211665722122921773.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 21/07/2014 06:13, David Miller a écrit :
> From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
> Date: Fri, 18 Jul 2014 16:21:14 +0200
> 
>> +		if (tx_skb->mapped_as_page) {
>> +			dma_unmap_page(&bp->pdev->dev, tx_skb->mapping,
>> +				       tx_skb->size, DMA_TO_DEVICE);
>> +		} else {
>> +			dma_unmap_single(&bp->pdev->dev, tx_skb->mapping,
>> +					 tx_skb->size, DMA_TO_DEVICE);
>> +		}
> 
> Please do not use curly braces for basic block composed of a single statement.
> 
Hi David,

thanks for your review, I'll fix it in the next series of patch.

Regards,

Cyrille
