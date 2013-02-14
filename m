Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab3BNEn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 23:43:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:7248 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab3BNEn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 23:43:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,662,1355126400"; 
   d="scan'208";a="202200287"
Date: Thu, 14 Feb 2013 10:12:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: dma.c: fix memory leakage
Message-ID: <20130214044230.GD7777@intel.com>
References: <1358600805-20193-1-git-send-email-dinggnu@gmail.com>
 <50FC6EB1.4050704@gmail.com>
 <20130122101053.GA2427@gmail.com>
 <20130212174025.GB17659@intel.com>
 <20130213112623.GA23860@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213112623.GA23860@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 12:26:23PM +0100, Cong Ding wrote:
> > > > You need to send this to whomever is working on DMA bindings.
> > > Thank you bob, I added Vinod the the receiver list.
> > I have moved the of/dma.c to dma/of-dma.c, can you regenerate this patch and
> > resend to me
> Sorry Vinod, I didn't manage to get this commit from either linux-next tree or
> slave-dma tree, and the last commit by you for of/dma.c file is on Jan 7. Did
> you have any hints for me to get the latest version dma/of-dma.c?
AH my bad, seems i have not pushed it out :(

Pushed now...

