Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaFCMuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:50:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:48210 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaFCMuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:50:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,965,1392192000"; 
   d="scan'208";a="440271914"
Date: Tue, 3 Jun 2014 15:49:53 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: eric.ernst@linux.intel.com
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        mark.gross@intel.com
Subject: Re: [PATCH v2 1/1] PINCTRL: Warn if direct IRQ GPIO set to output
Message-ID: <20140603124953.GJ1730@lahna.fi.intel.com>
References: <0140602191416.GD1730@lahna.fi.intel.com>
 <1401743527-47035-1-git-send-email-eric.ernst@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401743527-47035-1-git-send-email-eric.ernst@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:12:07PM -0700, eric.ernst@linux.intel.com wrote:
> +	WARN((readl(conf_reg) & BYT_DIRECTIRQ),
> +		"Potential Error: Setting GPIO with direct_irq_en to output");

Also you don't need parentheses here.
