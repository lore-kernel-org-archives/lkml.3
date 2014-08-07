Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbaHGQee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:34:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:28996 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238AbaHGQec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:34:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,819,1400050800"; 
   d="scan'208";a="581512585"
Date: Thu, 7 Aug 2014 21:53:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCHv2] dma: at_hdmac: fix invalid remaining bytes detection
Message-ID: <20140807162308.GD9692@intel.com>
References: <1406911906-397-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406911906-397-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 06:51:46PM +0200, Alexandre Belloni wrote:
> Found using smatch:
> drivers/dma/at_hdmac.c:299 atc_get_bytes_left() warn: unsigned
> 'atchan->remain_desc' is never less than zero.

Applied, thanks

-- 
~Vinod

