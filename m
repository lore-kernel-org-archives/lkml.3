Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbaATFa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 00:30:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:13241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaATFa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 00:30:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="467567616"
Date: Mon, 20 Jan 2014 09:59:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Rob Landley <rob@landley.net>
Cc: hongbo.zhang@freescale.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@redhat.com>,
        Richard Henderson <rth@cygnus.com>, Jakub Jelinek <jakub@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arthur Kepner <akepner@sgi.com>, sumit.semwal@linaro.org,
        Pierre Ossman <drzeus@drzeus.cx>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Subject: Re: [PATCH resend 1/2] Documentation: move all DMA documentations
 into Documentaion/dma
Message-ID: <20140120042909.GA26823@intel.com>
References: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com>
 <20140116155921.GJ25466@intel.com>
 <52DAC0F1.9080202@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DAC0F1.9080202@landley.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 11:59:13AM -0600, Rob Landley wrote:
> On 01/16/14 09:59, Vinod Koul wrote:
> >On Thu, Jan 16, 2014 at 06:50:04PM +0800, hongbo.zhang@freescale.com wrote:
> >>From: Hongbo Zhang <hongbo.zhang@freescale.com>
> >>
> >>Since there are already seven DMA documentations under the top Documentation/,
> >>it is better to create one dedicated directory for them.
> >
> >Well the problem is that not everything is same. Some of these mean how to use
> >dma mapping API, couple are related to dmaengine, so clubing everything into
> >"dma" doesnt sound right to me!
> 
> Putting everything in the world in the top level directory isn't all
> flowers and kittens either.
> 
> Where would be a _better_ place to move one of those files to?
As pointed mostly things dma* are dma-mapping and dmaengine, so would apt
that we move to two folders, unless i overlooked and assumed everything else is
dma-mapping!

--
~Vinod
