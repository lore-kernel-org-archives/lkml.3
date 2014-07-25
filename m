Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaGYFch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 01:32:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:26442 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaGYFcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 01:32:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,728,1400050800"; 
   d="scan'208";a="567019507"
Date: Fri, 25 Jul 2014 08:32:30 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: chiau.ee.chew@intel.com
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>, chiauee85@gmail.com
Subject: Re: [PATCH v2] spi/pxa2xx-pci: Add common clock framework support in
 PCI glue layer
Message-ID: <20140725053230.GT1857@lahna.fi.intel.com>
References: <1406221854-12828-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406221854-12828-1-git-send-email-chiau.ee.chew@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 01:10:54AM +0800, chiau.ee.chew@intel.com wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> SPI PXA2XX core layer has dependency on common clock framework
> to obtain information on host supported clock rate. Thus, we
> setup the clock device in the PCI glue layer to enable PCI mode
> host pass in the clock rate information.
> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> Acked-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>

Looks reasonable,

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
