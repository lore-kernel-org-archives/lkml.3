Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965921AbaFRKVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:21:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:24390 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965039AbaFRKVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:21:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,499,1400050800"; 
   d="scan'208";a="557319537"
Date: Wed, 18 Jun 2014 13:21:35 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benson Leung <bleung@chromium.org>
Cc: gene.chen@intel.com, moch@chromium.org, lkml14@scotdoyle.com,
        kirill.shutemov@linux.intel.com, olof@lixom.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/4] platform/chrome: chromeos_laptop - Add Dell
 Chromebook 11 touch
Message-ID: <20140618102135.GS1655@lahna.fi.intel.com>
References: <1401835464-15267-1-git-send-email-bleung@chromium.org>
 <1403038923-19444-1-git-send-email-bleung@chromium.org>
 <1403038923-19444-4-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403038923-19444-4-git-send-email-bleung@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 02:02:02PM -0700, Benson Leung wrote:
> From: Mohammed Habibulla <moch@chromium.org>
> 
> Add support for Dell Chromebook 11's touch device, which is the same
> as falco/peppy on the same bus using the LynxPoint-LP I2C via the
> i2c-designware-pci driver.
> 
> Based on these patches from the chromeos-3.8 kernel:
> https://chromium-review.googlesource.com/#/c/65320/
> https://chromium-review.googlesource.com/#/c/174664/
> 
> Signed-off-by: Mohammed Habibulla <moch@chromium.org>
> Signed-off-by: Benson Leung <bleung@chromium.org>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
