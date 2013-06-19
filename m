Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935031Ab3FSSI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:08:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:19496 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933869Ab3FSSI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:08:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,899,1363158000"; 
   d="scan'208";a="356303037"
Date: Wed, 19 Jun 2013 11:03:46 -0700
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH v2 1/4] mfd: Kontron PLD mfd driver
Message-ID: <20130619180346.GA14304@wrk>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1371589469-32700-1-git-send-email-kevin.strasser@linux.intel.com>
 <1371589469-32700-2-git-send-email-kevin.strasser@linux.intel.com>
 <alpine.DEB.2.02.1306191101290.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306191101290.4013@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 11:12:09AM +0200, Thomas Gleixner wrote:
> On Tue, 18 Jun 2013, Kevin Strasser wrote:
> 
> This patch set looks reasonable now, except a formal issue.
>  
> > Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> > Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> 
> This is wrong, as it says:
> 
>  Kevin authored the code, sent it to Michael and Michael sent it to
>  LKML.
> 
> 
> The original code was authored by Michael. This version was authored
> by Kevin based on Michaels code.
> 
> So either you keep Michael as the author, then you want 
> 
>  From: Michael Brunner <michael.brunner@kontron.com>
> 
>  <patch description/>
> 
>  Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
>  Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> 
> or you decide that it's a major rewrite by you, then you want:
> 
>  This patch is based on the original version authored by
>  Michael Brunner <michael.brunner@kontron.com>.
> 
>  Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> 
>  Or 
> 
>  Originally-From: Michael Brunner <michael.brunner@kontron.com>.
>  Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>

Ok, I think this will make sense for all the patches except gpio,
which is a major rewrite by Guenter.

So maybe this would be appropriate:

 From: Guenter Roeck <linux@roeck-us.net>

 <patch description>

 Originally-From: Michael Brunner <michael.brunner@kontron.com>
 Signed-off-by: Guenter Roeck <linux@roeck-us.net>
 Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
 ...

Thanks,
Kevin

> 
> Other than that.
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
