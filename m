Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaC2OPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 10:15:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:1315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaC2OPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 10:15:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,756,1389772800"; 
   d="scan'208";a="510193836"
Date: Sat, 29 Mar 2014 19:38:02 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux-SH <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v3] shdma: add R-Car Audio DMAC peri peri driver
Message-ID: <20140329140802.GS1976@intel.com>
References: <878uu6gle8.wl%kuninori.morimoto.gx@gmail.com>
 <87siqptu7g.wl%kuninori.morimoto.gx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siqptu7g.wl%kuninori.morimoto.gx@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 06:11:50PM -0700, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Add support Audio DMAC peri peri driver
> for Renesas R-Car Gen2 SoC, using 'shdma-base'
> DMA driver framework.
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Please run checkpatch *everytime* you generate a patch. I have fixes a simple
format error :(

Applied, now

-- 
~Vinod
