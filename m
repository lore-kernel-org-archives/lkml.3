Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaI2H16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 03:27:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:35190 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaI2H15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 03:27:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,618,1406617200"; 
   d="scan'208";a="480668271"
Date: Mon, 29 Sep 2014 10:27:52 +0300
From: Mika Westerberg <mika.westerberg@intel.com>
To: Loic Poulain <loic.poulain@intel.com>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        samuel.ortiz@intel.com, mathias.nyman@linux.intel.com,
        heikki.krogerus@linux.intel.com
Subject: Re: [PATCHv3] pinctrl: baytrail: Clear DIRECT_IRQ bit
Message-ID: <20140929072752.GD1786@lahna.fi.intel.com>
References: <1411740891-3311-1-git-send-email-loic.poulain@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411740891-3311-1-git-send-email-loic.poulain@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:14:51PM +0200, Loic Poulain wrote:
> Direct irq en bit should be cleared for pads using io mode.
> If not, the io based irq will never be detected.
> However, this bit can sometimes be misconfigured (BIOS issue).
> Force clearing of this bit in io mode and trigger a WARN.
> 
> Signed-off-by: Loic Poulain <loic.poulain@intel.com>

That's more like it,

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks!
