Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaDUQz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:55:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53614 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaDUQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:55:23 -0400
Message-ID: <53554D5F.9020105@ti.com>
Date: Mon, 21 Apr 2014 11:54:55 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v3 00/10] dma: edma: Fixes for cyclic (audio) operation
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod, Dan,

On 04/14/2014 06:41 AM, Peter Ujfalusi wrote:
> Hi,
> 
> Changes since v2:
> - Dropped patch 10 from v2 (simplify direction configuration...)
> - Dropped the channel priority related patches since we are going to go via
>   different route for configuring the priority.
> - Added ACK from Joel for the patches since they are not changed since v2
> 
> Changes since v1:
> - ASoC patches removed
> - Comments from Andriy Shevchenko addressed
> - patch added to fix cases when src/dst_maxburst is set to 0
> 
> The series contains now only:
> Support for DMA pause/resume in cyclic mode
> device_slave_caps callback and DMA_CYCLIC flag correction.
> While debugging the edma to get things sorted out I noticed that the debug was
> too verbose and the important information was hidden even when the we did not
> asked for verbose dmaengine debug.
> I have included some debug cleanups for the edma dmaengine driver also.

I reviewed/tested these patches and they look OK to me. Also the point
of contention was priority which is now dropped from the series. If the
patches look OK and there are no further review comments can they be
queued for -next?

I also have a memcpy and another fix patch for edma so I could queue all
together in my tree and send a consolidated pull request to make it easier.

thanks,
 -Joel

