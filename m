Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaDQHmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:42:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:38915 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaDQHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:42:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,877,1389772800"; 
   d="scan'208";a="522492287"
Date: Thu, 17 Apr 2014 10:49:42 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pwm_lpss: Add support for PCI devices
Message-ID: <20140417074942.GA30677@intel.com>
References: <1397672338-3510-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397672338-3510-1-git-send-email-chiau.ee.chew@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 02:18:58AM +0800, Chew Chiau Ee wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> Not all systems enumerate the PWM devices via ACPI. They can also be exposed
> via the PCI interface.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
