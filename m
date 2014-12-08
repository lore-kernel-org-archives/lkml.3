Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaLHNP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:15:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:4980 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaLHNP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:15:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="495417031"
Date: Mon, 8 Dec 2014 18:44:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stefan Agner <stefan@agner.ch>
Cc: jingchang.lu@freescale.com, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] dmaengine: fsl-edma: fix calculation of remaining bytes
Message-ID: <20141208131412.GL16827@intel.com>
References: <1415879762-12177-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415879762-12177-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 12:56:02PM +0100, Stefan Agner wrote:
> If the current transfer control descriptor (TCD) was not yet started,
> the address will be the same as the initial address. Hence test if the
> current address is less than or equal to the start address of each TCD.
Applied, thanks

-- 
~Vinod

