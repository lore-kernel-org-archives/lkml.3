Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbbAMP7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:59:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:34467 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbbAMP7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:59:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="661170854"
Date: Tue, 13 Jan 2015 21:28:28 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH 06/28] dma: drop owner assignment from platform_drivers
Message-ID: <20150113155828.GB14630@intel.com>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-7-git-send-email-wsa@the-dreams.de>
 <20141222153822.GP16827@intel.com>
 <20141231102350.GB1461@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141231102350.GB1461@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 11:23:50AM +0100, Wolfram Sang wrote:
> On Mon, Dec 22, 2014 at 09:08:22PM +0530, Vinod Koul wrote:
> > On Sun, Dec 21, 2014 at 10:14:27PM +0100, Wolfram Sang wrote:
> > > This platform_driver does not need to set an owner, it will be populated by the
> > > driver core.
> > > 
> > After susbstem name if fixed
> > 
> > Acked-by: Vinod Koul <vinod.koul@intel.com>
> 
> Since I'd prefer this to go via your tree, can you fix it or shall I
> resend?
Sorry I don't have this patch, would you mind resending

-- 
~Vinod

