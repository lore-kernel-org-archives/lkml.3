Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3AVD3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:29:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:22009 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab3AVD3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:29:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="193770526"
Date: Tue, 22 Jan 2013 04:28:52 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, tony@atomide.com, kishon@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/14] mfd: omap-usb-host: Remove PHY reset handling code
Message-ID: <20130122032852.GR7409@sortiz-mobl>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
 <1357836694-30788-9-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357836694-30788-9-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Roger,

On Thu, Jan 10, 2013 at 06:51:28PM +0200, Roger Quadros wrote:
> PHY reset GPIO handling will be done in the PHY driver
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
