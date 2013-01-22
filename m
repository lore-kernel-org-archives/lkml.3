Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3AVQ3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:29:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:29635 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab3AVQ3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:29:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,515,1355126400"; 
   d="scan'208";a="275227540"
Date: Tue, 22 Jan 2013 17:29:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH] mfd: vexpress: export global functions to fix build error
Message-ID: <20130122162940.GB6013@sortiz-mobl>
References: <1357463779-28096-1-git-send-email-linux@roeck-us.net>
 <20130122033042.GV7409@sortiz-mobl>
 <20130122122026.GA12038@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122122026.GA12038@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Tue, Jan 22, 2013 at 04:20:26AM -0800, Guenter Roeck wrote:
> On Tue, Jan 22, 2013 at 04:30:42AM +0100, Samuel Ortiz wrote:
> > Hi Guenter,
> > 
> > On Sun, Jan 06, 2013 at 01:16:19AM -0800, Guenter Roeck wrote:
> > > Compiling vexpress client drivers as module results in error messages such as
> > > 
> > > ERROR: "__vexpress_config_func_get" [drivers/hwmon/vexpress.ko] undefined!
> > > ERROR: "vexpress_config_func_put" [drivers/hwmon/vexpress.ko] undefined!
> > > 
> > > This is because the global functions in drivers/mfd/vexpress-config.c are not
> > > exported. Fix it.
> > > 
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > ---
> > >  drivers/mfd/vexpress-config.c |    8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > Applied, thanks for the fix.
> > 
> Caution: Looks like I misspelled EXPORT_SYMBOL.
I fixed that now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
