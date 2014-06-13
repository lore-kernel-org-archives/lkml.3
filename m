Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaFMNKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:10:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:65222 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaFMNKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:10:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,471,1400050800"; 
   d="scan'208";a="556983839"
Date: Fri, 13 Jun 2014 16:10:08 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] spi/pxa2xx: fix incorrect SW mode chipselect setting
 for BayTrail LPSS SPI
Message-ID: <20140613131008.GK21178@lahna.fi.intel.com>
References: <1402675045-22460-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402675045-22460-1-git-send-email-chiau.ee.chew@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 11:57:25PM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> It was observed that after module removal followed by insertion,
> the SW mode chipselect is not properly set. Thus causing transfer
> failure due to incorrect CS toggling.
> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
