Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3FYSX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:23:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:36356 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab3FYSX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:23:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,938,1363158000"; 
   d="scan'208";a="359424569"
Date: Tue, 25 Jun 2013 11:23:56 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: George Cherian <george.cherian@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] usb: host: xhci-plat: release mem region while removing
 module
Message-ID: <20130625182356.GB28833@xanatos>
References: <1371803348-9807-1-git-send-email-george.cherian@ti.com>
 <20130624142224.GI21889@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624142224.GI21889@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 05:22:24PM +0300, Felipe Balbi wrote:
> On Fri, Jun 21, 2013 at 01:59:08PM +0530, George Cherian wrote:
> > Do a release_mem_region of the hcd resource. Without this the
> > subsequent insertion of module fails in request_mem_region.
> > 
> > Signed-off-by: George Cherian <george.cherian@ti.com>
> 
> very nice catch.
> 
> Acked-by: Felipe Balbi <balbi@ti.com>
> 
> You need to resend with:
> 
> 	Cc: <stable@vger.kernel.org> # v3.4+
> 
> Not sure if Sarah wants to take care of the stable tagging, though.

I'll take care of the stable tagging.

Sarah Sharp
