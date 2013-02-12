Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701Ab3BLSFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:05:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:12523 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933631Ab3BLSFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:05:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290180386"
Date: Tue, 12 Feb 2013 09:40:25 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: dma.c: fix memory leakage
Message-ID: <20130212174025.GB17659@intel.com>
References: <1358600805-20193-1-git-send-email-dinggnu@gmail.com>
 <50FC6EB1.4050704@gmail.com>
 <20130122101053.GA2427@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122101053.GA2427@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:10:53AM +0000, Cong Ding wrote:
> On Sun, Jan 20, 2013 at 04:24:49PM -0600, Rob Herring wrote:
> > On 01/19/2013 07:06 AM, Cong Ding wrote:
> > > The memory allocated to ofdma might be a leakage when error occurs.
> > > 
> > > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > 
> > You need to send this to whomever is working on DMA bindings.
> Thank you bob, I added Vinod the the receiver list.
I have moved the of/dma.c to dma/of-dma.c, can you regenerate this patch and
resend to me

--
~Vinod
