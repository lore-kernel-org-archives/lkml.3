Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3G2MdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:33:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:46248 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3G2MdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:33:15 -0400
Message-ID: <51F66108.9030506@linutronix.de>
Date: Mon, 29 Jul 2013 14:33:12 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 15/16] dmaengine: add transfered member to dma_async_tx_descriptor
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-16-git-send-email-bigeasy@linutronix.de> <20130729113933.GK29095@intel.com>
In-Reply-To: <20130729113933.GK29095@intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 01:39 PM, Vinod Koul wrote:
>> @@ -416,6 +418,7 @@ struct dma_async_tx_descriptor {
>>  	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
>>  	dma_async_tx_callback callback;
>>  	void *callback_param;
>> +	unsigned int transfered;
> I think this should be doable with residue as well. You can return DMA_SUCCESS
> for status and fill in what is NOT transfered indicating that txn completed but
> lesser number of bytes are valid

Yes, will do.

> 
> ~Vinod
> 
Sebastian
