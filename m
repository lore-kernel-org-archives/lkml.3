Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab3GWRMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:12:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:47879 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab3GWRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:12:18 -0400
Message-ID: <51EEB96B.8070407@linutronix.de>
Date: Tue, 23 Jul 2013 19:12:11 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 15/16] dmaengine: add transfered member to dma_async_tx_descriptor
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-16-git-send-email-bigeasy@linutronix.de> <51ED7F7C.2080205@cogentembedded.com>
In-Reply-To: <51ED7F7C.2080205@cogentembedded.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 08:52 PM, Sergei Shtylyov wrote:
>> @@ -416,6 +418,7 @@ struct dma_async_tx_descriptor {
>>       dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
>>       dma_async_tx_callback callback;
>>       void *callback_param;
>> +    unsigned int transfered;
> 
>    Correct grammar is "transferred".

Thanks, corrected.

> 
> WBR, Sergei

Sebastian
