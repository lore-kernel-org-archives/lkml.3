Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3AVD37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:29:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:24761 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636Ab3AVD35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:29:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="276779778"
Date: Tue, 22 Jan 2013 04:29:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, tony@atomide.com, kishon@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/14] mfd: omap-usb-host: update nports in platform_data
Message-ID: <20130122032939.GS7409@sortiz-mobl>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
 <1357836694-30788-7-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357836694-30788-7-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Thu, Jan 10, 2013 at 06:51:26PM +0200, Roger Quadros wrote:
> EHCI driver would need to know the number of ports available
> on the platform. We set the nports parameter of platform_data
> based on IP version if it was not already provided.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
