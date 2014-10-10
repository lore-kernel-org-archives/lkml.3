Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaJJQp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 12:45:27 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58188 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaJJQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 12:45:23 -0400
Date: Fri, 10 Oct 2014 22:15:15 +0530
From: Akshay Sarode <akshaysarode21@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Checkpatch: coding style errors in Nvidia ethernet
 driver
Message-ID: <20141010164515.GA3596@linux.akshay.com>
References: <1412928102-1696-1-git-send-email-akshaysarode21@gmail.com>
 <1412953387.8770.23.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412953387.8770.23.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 08:03:07AM -0700, Joe Perches wrote:
> On Fri, 2014-10-10 at 13:31 +0530, Akshay Sarode wrote:
> > ERROR: "foo* bar" should be "foo *bar"
> > ERROR: do not initialise statics to 0 or NULL
> > CHECK: spinlock_t definition without comment
> > Signed-off-by: Akshay Sarode <akshaysarode21@gmail.com>
> []
> > diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> []
> > @@ -911,12 +913,18 @@ enum {
> []
> >  /*
> >   * Debug output control for tx_timeout
> >   */
> > -static bool debug_tx_timeout = false;
> > +enum {
> > +	NV_DEBUG_TX_TIMEOUT_DISABLED,
> > +	NV_DEBUG_TX_TIMEOUT_ENABLED
> > +};
> > +
> > +static bool debug_tx_timeout = NV_DEBUG_TX_TIMEOUT_DISABLED;
> 
> Adding this enum is not useful.
> 
Sorry, If I may have not checked the code properly. I am a newbie here and I was hoping to start with checking coding styles.
I'll check again. Also there are a whole lot of warnings for line over 80 characters.

Regards,
Akshay 
