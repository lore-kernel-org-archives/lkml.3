Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab3C2OgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:36:11 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:37986 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab3C2OgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:36:10 -0400
Date: Fri, 29 Mar 2013 15:36:07 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] dmaengine: omap-dma: Start DMA without delay
In-Reply-To: <1364566323-24144-1-git-send-email-peter.ujfalusi@ti.com>
Message-ID: <alpine.DEB.2.01.1303291533540.26456@pmeerw.net>
References: <1364566323-24144-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Remove the use of a tasklet to start the DMA channel when issue_pending is
> called.
> The use of tasklet delays the DMA start which can cause issues at drivers,
> for example the audio drivers expect that the DMA is started right away.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

I've reported the problem and now tested the patch applied on top of 
3.8.5, running on beagle-xm; sounds good, so

Tested-by: Peter Meerwald <p.meerwald@bct-electronic.com>

-- 

Peter Meerwald
+43-664-2444418 (mobile)
