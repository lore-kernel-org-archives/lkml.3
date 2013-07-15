Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab3GOQ77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:59:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:17574 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174Ab3GOQ76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:59:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,670,1367996400"; 
   d="scan'208";a="268556220"
Date: Mon, 15 Jul 2013 21:51:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Matt Porter <matt@ohporter.com>
Subject: Re: [PATCH] dmaengine: add dma_slave_get_caps api
Message-ID: <20130715162106.GT16653@intel.com>
References: <1373273650-31097-1-git-send-email-vinod.koul@intel.com>
 <1373883687-10146-1-git-send-email-vinod.koul@intel.com>
 <51E41A86.4030200@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E41A86.4030200@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 05:51:34PM +0200, Lars-Peter Clausen wrote:
> On 07/15/2013 12:21 PM, Vinod Koul wrote:
> [...]
> > + * @max_seg_nr: maximum number of SG segments supported
> > + * 	0 for no maximum
> > + * @max_seg_len: maximum length of a SG segment supported
> > + * 	0 for no maximum
> [...]
> > +	u32 max_sg_nr;
> > +	u32 max_sg_len;
> 
> seg vs. sg
Thanks, fixed and applied now to topic/api_caps

--
~Vinod
