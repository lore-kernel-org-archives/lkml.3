Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaKLJlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:41:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:52880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbaKLJlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:41:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,367,1413270000"; 
   d="scan'208";a="621072815"
Date: Wed, 12 Nov 2014 15:09:52 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DMA: Fix allocation size for PL330 data buffer depth.
Message-ID: <20141112093952.GD24582@intel.com>
References: <1415294412-13818-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415294412-13818-1-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:20:12PM +0000, Liviu Dudau wrote:
> The datasheet for PL330 says that the data buffer value in the CRD
> register is 10bits wide. However, the value stored is "minus one",
> which the driver corrects for. Maximum value that the data buffer
> depth can have is 1024 lines, which requires 11 bits for storage.
> 
> While making updates I found printing the peripheral ID as a hex
> value to be more useful as the datasheet shows the values that way.

Applied, thanks

Please snure you use the right subsytem name

-- 
~Vinod
