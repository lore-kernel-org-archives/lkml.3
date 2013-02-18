Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3BRNYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:24:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:24972 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab3BRNYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:24:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,687,1355126400"; 
   d="scan'208";a="258366813"
Date: Mon, 18 Feb 2013 15:28:44 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v3] i2c-designware: make SDA hold time configurable
Message-ID: <20130218132843.GA2439@intel.com>
References: <20130218105742.GK20771@intel.com>
 <1361191905-30099-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361191905-30099-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 01:51:45PM +0100, Christian Ruppert wrote:
> This patch makes the SDA hold time configurable through device tree.
> It was tested on a hybrid of i2c/next and arc-3.8-baseline (see
> https://github.com/foss-for-synopsys-dwc-arc-processors/linux/commits/arc-3.8-baseline) since our platform is ARC based and this architecture is not yet
> supported by i2c/next.
> 
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks!
