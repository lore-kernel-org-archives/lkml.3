Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935583Ab3DIJAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:00:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:9710 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934875Ab3DIJAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:00:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,437,1363158000"; 
   d="scan'208";a="283562200"
Date: Tue, 9 Apr 2013 11:00:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 0/6] mfd: omap-usb-host: Device tree support for 3.10
Message-ID: <20130409090027.GE23447@zurbaran>
References: <20130409075457.GF24058@zurbaran>
 <1365496758-16287-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365496758-16287-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:39:16AM +0300, Roger Quadros wrote:
> Samuel,
> 
> You had the conflicts because a patch [*] was introduced and is not
> required since the reset logic is being removed from the driver.
> 
> Anyways, I've rebased the 2 patches on top of mfd-next, so now it
> shouldn't matter.
Both patches applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
