Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaCZG3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 02:29:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:7168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaCZG3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 02:29:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,734,1389772800"; 
   d="scan'208";a="480184738"
Date: Wed, 26 Mar 2014 11:53:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lim Lee Booi <lee.booi.lim@intel.com>
Subject: Re: [PATCH v2] dma: dw: Add suspend and resume handling for PCI
 mode DW_DMAC.
Message-ID: <20140326062306.GM1976@intel.com>
References: <1394820159-562-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394820159-562-1-git-send-email-chiau.ee.chew@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 02:02:39AM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> This is to disable/enable DW_DMAC hw during late suspend/early resume.
> Since DMA is providing service to other clients (eg: SPI, HSUART),
> we need to ensure DMA suspends after the clients and resume
> before the clients are active.
> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Rather than bunch of ifdef, would make sense to provde a mcros in dmaengine core
to do so as we expect all dmaengine drivers to be late probe

Applied thanks

-- 
~Vinod
