Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaLCQUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:20:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaLCQTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:19:48 -0500
Date: Wed, 3 Dec 2014 08:17:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: tony@atomide.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        andrew.kim@intel.com
Subject: Re: [PATCH] arm: omap3: twl: remove usb phy init data
Message-ID: <20141203161755.GB5062@kroah.com>
References: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1416410903-162369-5-git-send-email-heikki.krogerus@linux.intel.com>
 <547EA275.8050208@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547EA275.8050208@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:11:09AM +0530, Kishon Vijay Abraham I wrote:
> Hi Greg,
> 
> On Monday 01 December 2014 02:14 PM, Kishon Vijay Abraham I wrote:
> > From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > 
> > The driver does no use it any more.
> > 
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> This patch is required to get rid of the error that Stephen Rothwell reported.

Then please resend it in a format that I can apply it in.

thanks,

greg k-h
