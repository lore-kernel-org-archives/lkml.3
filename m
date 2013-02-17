Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3BQPIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:08:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:24720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241Ab3BQPI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:08:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,682,1355126400"; 
   d="scan'208";a="292247186"
Date: Sun, 17 Feb 2013 20:37:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] dma: tegra: assume CONFIG_OF
Message-ID: <20130217150735.GK29960@intel.com>
References: <1360965237-14857-1-git-send-email-swarren@wwwdotorg.org>
 <CAA9_cme3e-VWFs+5o6g88dXmURsjojT08o9Cw+=r7=AfRKz5gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cme3e-VWFs+5o6g88dXmURsjojT08o9Cw+=r7=AfRKz5gQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 02:18:59PM -0800, Dan Williams wrote:
> On Fri, Feb 15, 2013 at 1:53 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > From: Stephen Warren <swarren@nvidia.com>
> >
> > Tegra only supports, and always enables, device tree. Remove all ifdefs
> > and runtime checks for DT support from the driver.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Acked-by: Dan Williams <djbw@fb.com>
> 
> ..adding Vinod.
I think it should assume CONFIG_DMA_OF?

--
~Vinod
