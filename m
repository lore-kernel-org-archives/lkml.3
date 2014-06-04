Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaFDIWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:22:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:22880 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaFDIWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:22:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,971,1392192000"; 
   d="scan'208";a="551340725"
Date: Wed, 4 Jun 2014 11:22:40 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: eric.ernst@linux.intel.com
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        mark.gross@intel.com
Subject: Re: [PATCH v3 1/1] pinctrl: baytrail: Warn if direct IRQ GPIO set to
 output
Message-ID: <20140604082240.GM1730@lahna.fi.intel.com>
References: <20140603110600.GG1730@lahna.fi.intel.com>
 <1401834316-199359-1-git-send-email-eric.ernst@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401834316-199359-1-git-send-email-eric.ernst@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:25:16PM -0700, eric.ernst@linux.intel.com wrote:
> From: Eric Ernst <eric.ernst@linux.intel.com>
> 
> For Baytrail, you should never set a GPIO set to direct_irq
> to output mode.  When direct_irq_en is set for a GPIO, it is
> tied directly to an APIC internally, and making the pad output
> does not make any sense. Assert a WARN() in the event this happens.
> 
> Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>

Looks good now thanks,

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
