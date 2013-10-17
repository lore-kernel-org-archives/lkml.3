Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678Ab3JQAb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:31:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55613 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760544Ab3JQAb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:31:57 -0400
Message-ID: <525F2FD8.9090008@ti.com>
Date: Wed, 16 Oct 2013 19:31:20 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <g.liakhovetski@gmx.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 09/28] dmaengine: edma: use DMA_COMPLETE for dma completion
 status
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com> <1381940926-25564-10-git-send-email-vinod.koul@intel.com>
In-Reply-To: <1381940926-25564-10-git-send-email-vinod.koul@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 11:28 AM, Vinod Koul wrote:
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> CC: Joel Fernandes <joelf@ti.com>

The audio davinci-pcm driver once converted to dmaengine usage would be the
first user of tx_status so I will get to testing this patch better then.

Anyway, with this patch applied I compile-tested and boot-tested it and it
doesn't appear to break anything.

Tested-by: Joel Fernandes <joelf@ti.com>

thanks,

-Joel
