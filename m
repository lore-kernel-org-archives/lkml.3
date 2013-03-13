Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab3CMIea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:34:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:23802 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab3CMIe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:34:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,834,1355126400"; 
   d="scan'208";a="278056679"
Date: Wed, 13 Mar 2013 09:34:22 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Roger Quadros <rogerq@ti.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>
Subject: Re: mfd: omap-usb-host: bug fix for 3.9
Message-ID: <20130313083422.GA21994@zurbaran>
References: <512E120D.7000101@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E120D.7000101@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Wed, Feb 27, 2013 at 04:02:53PM +0200, Roger Quadros wrote:
> Hi Samuel,
> 
> One of my patch that I sent for 3.9 introduces a bug that fails to
> update the port mode hostconfig register. Because of that, the port modes will
> always be 0 (i.e. EHCI PHY mode) and other modes will not work. PHY mode will
> work, so beagle/panda have no issues.
> 
> Since my hardware setup uses only PHY mode, I couldn't catch this problem earlier.
> 
> Below is the fix.
> 
> From 82466757a212bd8b54d806c9d56b1acccbd4d464 Mon Sep 17 00:00:00 2001
> From: Roger Quadros <rogerq@ti.com>
> Date: Wed, 27 Feb 2013 15:19:24 +0200
> Subject: [PATCH] mfd: omap-usb-host: Actually update hostconfig
> 
> The helper functions omap_usbhs_rev1_hostconfig()
> and omap_usbhs_rev2_hostconfig() don't write into
> the hostconfig register. Make sure that we write
> the return value into the hostconfig register.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
Patch applied now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
