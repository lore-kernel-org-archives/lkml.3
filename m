Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaHSPN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:13:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:59696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbaHSPNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:13:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,894,1400050800"; 
   d="scan'208";a="560604498"
Date: Tue, 19 Aug 2014 20:27:34 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140819145734.GN13288@intel.com>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140814085301.GJ2452@ldesroches-Latitude-E6320>
 <20140814085753.GS30401@n2100.arm.linux.org.uk>
 <20140819134507.GJ13288@intel.com>
 <20140819144423.GE30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819144423.GE30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 03:44:23PM +0100, Russell King - ARM Linux wrote:
> On Tue, Aug 19, 2014 at 07:15:07PM +0530, Vinod Koul wrote:
> > On Thu, Aug 14, 2014 at 09:57:53AM +0100, Russell King - ARM Linux wrote:
> > > It's got something to do with the async engine API, and seems to be
> > > something to do with whether a descriptor can have other transactions
> > > added to it, and whether a descriptor can be re-used (async-tx engines
> > > typically allocate a fixed set of descriptors and recycle them.)
> > Yes this is my understanding too. Async API IIUC can reuse descriptors and
> > if engine doesnt support this is a way to tell them please do use that.
> > 
> > For slave dmanegine API we need to ignore it.
> 
> We shouldn't ignore it - ignoring it makes it harder to implement a DMA
> engine driver which supports both the slave and async APIs, because
> we then need to know the reason for the channel being requested.
Do you have such usage coming up near future :)
> 
> Ignoring it until it can be understood and documented is an approach I
> would agree with though.
Certainly, I am asking Dan to add more clarity on these bits to help
improve.

-- 
~Vinod
