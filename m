Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965428Ab3E2JcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:32:03 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:34304 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965388Ab3E2JcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:32:01 -0400
Date: Wed, 29 May 2013 11:31:03 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/6] Convert JZ4740 to dmaengine
Message-ID: <20130529093103.GA6426@linux-mips.org>
References: <1369341387-19147-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369341387-19147-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:36:21PM +0200, Lars-Peter Clausen wrote:

> done in 3 steps:
> 	1) Add a dmaengine driver which wraps the custom JZ4740 DMA API
> 	2) Update all users of the JZ4740 DMA API to use dmaengine instead
> 	3) Remove the custom API and move all direct hardware access to the
> 	   dmaengine driver.
> 
> The first two patches in the series also make sure that the clock of the DMA
> core is enabled.
> 
> Since the patches in this series depend on each other I'd prefer if they could
> all go through the DMA tree.

No problem - though my experience is that code for MIPS systems, including
drivers receives most testing if it lives in the MIPS git tree, less in
linux-next and barely any in in other subsystem-specific trees.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
