Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423120Ab3FUDUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 23:20:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:50433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422901Ab3FUDUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 23:20:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,910,1363158000"; 
   d="scan'208";a="357149244"
Date: Fri, 21 Jun 2013 08:10:39 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dan Williams <djbw@fb.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] at_hdmac: prepare clk before calling enable
Message-ID: <20130621024039.GA23141@intel.com>
References: <1371640263-9268-1-git-send-email-b.brezillon@overkiz.com>
 <1371640494-9472-1-git-send-email-b.brezillon@overkiz.com>
 <51C2B2B8.2040104@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C2B2B8.2040104@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 09:43:52AM +0200, Nicolas Ferre wrote:
> On 19/06/2013 13:14, Boris BREZILLON :
> >Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> >avoid common clk framework warnings.
> >
> >Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> BTW Vinod, it seems that we have several slave-dma patches pending:
> do you want me to collect them and send you a pull-request for 3.11?
I think those are the DT binding one, right? Sorry have been quite busy and
travelling. I could use the help right now...

--
~Vinod
