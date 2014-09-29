Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaI2J4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:56:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:33107 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbaI2J4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:56:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,619,1406617200"; 
   d="scan'208";a="606903946"
Date: Mon, 29 Sep 2014 12:53:20 +0300
From: Mika Westerberg <mika.westerberg@intel.com>
To: Weike Chen <alvin.chen@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Raymond Tan <raymond.tan@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 1/2 v2] SPI: spi-pxa2xx: Add helpers for regiseters'
 accessing
Message-ID: <20140929095320.GE1786@lahna.fi.intel.com>
References: <1412000548-9908-1-git-send-email-alvin.chen@intel.com>
 <1412000548-9908-2-git-send-email-alvin.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412000548-9908-2-git-send-email-alvin.chen@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 07:22:27AM -0700, Weike Chen wrote:
> Introduce helper functions to access the 'SSCR0' and 'SSCR1'.
> 
> Signed-off-by: Weike Chen <alvin.chen@intel.com>

Please fix the minor issues Andy pointed out and then you can have my,

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
