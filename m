Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994Ab3D3JVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:21:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:61278 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759627Ab3D3JVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:21:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,580,1363158000"; 
   d="scan'208";a="330014180"
Date: Tue, 30 Apr 2013 14:18:25 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: ludovic.desroches@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-i2c@vger.kernel.org,
        plagnioj@jcrosoft.com,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] at_hdmac: move to generic DMA binding
Message-ID: <20130430084825.GA1960@intel.com>
References: <1366362683-14496-1-git-send-email-ludovic.desroches@atmel.com>
 <1366362683-14496-2-git-send-email-ludovic.desroches@atmel.com>
 <51750F68.4040701@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51750F68.4040701@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 12:22:32PM +0200, Nicolas Ferre wrote:
> On 04/19/2013 11:11 AM, ludovic.desroches@atmel.com :
> > From: Ludovic Desroches <ludovic.desroches@atmel.com>
> > 
> > Update at_hdmac driver to support generic DMA device tree binding. Devices
> > can still request channel with dma_request_channel() then it doesn't break
> > DMA for non DT boards.
> > 
> > Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
Applied now thanks

--
~Vinod
