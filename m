Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaLEQlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:41:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:42273 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaLEQlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:41:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="494308240"
Date: Fri, 5 Dec 2014 22:11:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Robin Gong <b38343@freescale.com>
Cc: dan.j.williams@intel.com, andriy.shevchenko@linux.jf.intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] dma: imx-sdma: reorg code to make code clean
Message-ID: <20141205164144.GP3411@intel.com>
References: <1414030940-15516-1-git-send-email-b38343@freescale.com>
 <1414030940-15516-4-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414030940-15516-4-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:22:20AM +0800, Robin Gong wrote:
> Code reorg for transfer prepare and bus width check to make code
> cleaner.
This should have been 1st patch :(

-- 
~Vinod

