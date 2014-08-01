Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaHARcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:32:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:35991 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaHARcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:32:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,781,1400050800"; 
   d="scan'208";a="578834054"
Date: Fri, 1 Aug 2014 22:52:56 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140801172256.GH8181@intel.com>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <20140731132223.GK30282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731132223.GK30282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 02:22:23PM +0100, Russell King - ARM Linux wrote:
> DMA engine has lacked a lot of infrastructure for common patterns in
> drivers; some of that is solved by my efforts with the virt_dma.c
> support, and also various cleanups to existing drivers, but it's not
> easy to fix this problem after drivers have been merged.
I think list management is something that needs fix. I see lots of time and
energy being spent by drivers in this.
I will plan for this in near future to move descriptor and list management
to the framework. That should help drivers get cleaned up a bit more

-- 
~Vinod
