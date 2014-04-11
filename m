Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaDKT6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 15:58:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54577 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaDKT6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 15:58:31 -0400
Message-ID: <5348493C.8040408@ti.com>
Date: Fri, 11 Apr 2014 14:57:48 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: Re: [PATCH v2 10/14] dma: edma: Simplify direction configuration
 in edma_config_pset()
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-11-git-send-email-peter.ujfalusi@ti.com> <53471DC5.4090001@ti.com> <53478E0E.8040709@ti.com>
In-Reply-To: <53478E0E.8040709@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 01:39 AM, Peter Ujfalusi wrote:
> On 04/11/2014 01:40 AM, Joel Fernandes wrote:
>> On 04/01/2014 08:06 AM, Peter Ujfalusi wrote:
>>> We only support DEV_TO_MEM or MEM_TO_DEV directions with edma driver and the
>>> check for the direction has been already done in the function calling
>>> edma_config_pset().
>>> The error reporting is redundant and also the "else if ()" can be removed.
>>>
>>
>> NAK. Please don't do this. I have been working on MEM_TO_MEM support as
>> well so leave it as it is for future.
> 
> Sure. It is still valid to say that the error else {} will never going to
> happen since you have the same check in the calling function and they already
> filtered the non implemented direction.
> 

That's true. Though the patch removes the else if which would mean more
work later ;)

> I'll leave this out from v3.

Thanks.

Regards,
-Joel

