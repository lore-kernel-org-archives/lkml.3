Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaLVPfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:35:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:20649 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbaLVPfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:35:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="432181294"
Date: Mon, 22 Dec 2014 21:05:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dma: imx-dma.c:  Remove unused function
Message-ID: <20141222153517.GO16827@intel.com>
References: <1419182302-9672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419182302-9672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 06:18:22PM +0100, Rickard Strandqvist wrote:
> Remove the function is_imx21_dma() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
Please ensure you use *right* subsystem name

Applied, thanks

-- 
~Vinod

