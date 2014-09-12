Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaILNur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:50:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:33106 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbaILNuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:50:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,513,1406617200"; 
   d="scan'208";a="572307723"
Date: Fri, 12 Sep 2014 16:50:35 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/6] arm: omap3: twl: use the new lookup method with usb
 phy
Message-ID: <20140912135035.GB30816@xps8300>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1408620803-10464-4-git-send-email-heikki.krogerus@linux.intel.com>
 <5411BF17.1060909@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411BF17.1060909@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 08:56:15PM +0530, Kishon Vijay Abraham I wrote:
> > +static struct phy_lookup twl4030_usb_lookup = {
> > +	.phy_name	= "phy-twl4030_usb.0",
> > +	.dev_id		= "musb-hdrc.0",
> > +	.con_id		= "usb",
> >  };
> 
> Can use PHY_LOOKUP no?

I'll fix this.

Thanks,

-- 
heikki
