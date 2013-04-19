Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628Ab3DSW33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 18:29:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47436 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933870Ab3DSW32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 18:29:28 -0400
Message-ID: <5171C541.1040305@ti.com>
Date: Fri, 19 Apr 2013 17:29:21 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dma: of: Fix of_node reference leak
References: <1366364534-3298-1-git-send-email-lars@metafoo.de> <201304191210.27151.arnd@arndb.de>
In-Reply-To: <201304191210.27151.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.0.117]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/19/2013 05:10 AM, Arnd Bergmann wrote:
> On Friday 19 April 2013, Lars-Peter Clausen wrote:
>> of_dma_request_slave_channel() currently does not drop the reference to the
>> dma_spec of_node if no DMA controller matching the of_node could be found. This
>> patch fixes it by always calling of_node_put().
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks! FWIW ...

Reviewed-by: Jon Hunter <jon-hunter@ti.com>

Cheers
Jon

