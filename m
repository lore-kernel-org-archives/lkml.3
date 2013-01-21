Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3AUR5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:57:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:49111 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab3AUR5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:57:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,508,1355126400"; 
   d="scan'208";a="274754091"
Date: Mon, 21 Jan 2013 10:57:41 -0700
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 15/21] NTB: Update Version
Message-ID: <20130121175740.GF22208@jonmason-lab>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
 <1358586155-23322-16-git-send-email-jon.mason@intel.com>
 <20130120234714.GA21708@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130120234714.GA21708@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 03:47:14PM -0800, Greg KH wrote:
> On Sat, Jan 19, 2013 at 02:02:29AM -0700, Jon Mason wrote:
> > Update NTB version to 0.25
> > 
> > Signed-off-by: Jon Mason <jon.mason@intel.com>
> > ---
> >  drivers/ntb/ntb_hw.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> > index b792ccd..df86882 100644
> > --- a/drivers/ntb/ntb_hw.c
> > +++ b/drivers/ntb/ntb_hw.c
> > @@ -56,7 +56,7 @@
> >  #include "ntb_regs.h"
> >  
> >  #define NTB_NAME	"Intel(R) PCI-E Non-Transparent Bridge Driver"
> > -#define NTB_VER		"0.24"
> > +#define NTB_VER		"0.25"
> 
> I'm not objecting to this, but in the end, does it really matter?  Why
> not just stick with whatever kernel version you are using?  Keeping this
> up to date is going to be hard over the long haul, right?

Currently, it is a convenient way to verify the people testing the
code are running the latest version, since they are usually running
their tests on a stable kernel.  As the code becomes more stable, I
can see this becoming unnecessary and I will remove it then.

Thanks,
Jon

> 
> thanks,
> 
> greg k-h
