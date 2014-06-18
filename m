Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965978AbaFRKWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:22:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:17804 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965039AbaFRKWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:22:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,499,1400050800"; 
   d="scan'208";a="446958673"
Date: Wed, 18 Jun 2014 13:22:12 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benson Leung <bleung@chromium.org>
Cc: gene.chen@intel.com, moch@chromium.org, lkml14@scotdoyle.com,
        kirill.shutemov@linux.intel.com, olof@lixom.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/4] platform/chrome: chromeos_laptop - Add Toshiba
 CB35 Touch
Message-ID: <20140618102212.GT1655@lahna.fi.intel.com>
References: <1401835464-15267-1-git-send-email-bleung@chromium.org>
 <1403038923-19444-1-git-send-email-bleung@chromium.org>
 <1403038923-19444-5-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403038923-19444-5-git-send-email-bleung@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 02:02:03PM -0700, Benson Leung wrote:
> From: Gene Chen <gene.chen@intel.com>
> 
> Add support for Leon touch devices, which is the same as
> falco/peppy/wolf on the same buses using the LynxPoint-LP I2C
> via the i2c-designware-pci driver.
> 
> Based on these patches from the chromeos-3.8 kernel:
> https://chromium-review.googlesource.com/168351
> https://chromium-review.googlesource.com/173445
> 
> Signed-off-by: Gene Chen <gene.chen@intel.com>
> Signed-off-by: Benson Leung <bleung@chromium.org>
> Tested-by: Scot Doyle <lkml14@scotdoyle.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
