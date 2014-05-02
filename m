Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaEBQca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:32:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:8361 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbaEBQc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:32:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="533729281"
Date: Fri, 2 May 2014 21:49:55 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Linux-SH <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/2] DMA: shdma: tidyup callback chunk finder
Message-ID: <20140502161955.GY32284@intel.com>
References: <87lhvnrtkw.wl%kuninori.morimoto.gx@gmail.com>
 <87k3b7rtjw.wl%kuninori.morimoto.gx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3b7rtjw.wl%kuninori.morimoto.gx@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 08:16:51PM -0700, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Current shdma is using "last" which indicates last desc
> which needs to have callback function.
> but, that desc's chunks is always 1
> We can use it as finder
> 
Applied both with reflow of changelog.

Also in future pls use right subsystem name "dmaengine"

-- 
~Vinod
