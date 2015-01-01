Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbbAAE7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 23:59:06 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52495 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbbAAE7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 23:59:05 -0500
Date: Thu, 1 Jan 2015 10:28:49 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: gregkh@linuxfoundation.org, anarey@gmail.com, mcgrof@do-not-panic.com,
        tapaswenipathak@gmail.com, joe@perches.com, rmfrfs@gmail.com,
        yejiayily@gmail.com, gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] staging: rtl8192u: remove redundant code
Message-ID: <20150101045848.GC3645@sudip-PC>
References: <1420060243-10685-1-git-send-email-lstoakes@gmail.com>
 <1420060243-10685-3-git-send-email-lstoakes@gmail.com>
 <20150101044956.GB3645@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150101044956.GB3645@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 10:19:56AM +0530, Sudip Mukherjee wrote:
> On Wed, Dec 31, 2014 at 09:10:42PM +0000, Lorenzo Stoakes wrote:
> > This patch fixes warnings/errors raised by checkpatch.pl relating to redundant
> > code in r8192U_dm.c.
> > 
> > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > ---
> >  drivers/staging/rtl8192u/r8192U_dm.c | 176 +++++++++++++++++------------------
> >  1 file changed, 84 insertions(+), 92 deletions(-)
> > 
> > diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
> > index 862d2ab..ed566bb 100644
> > --- a/drivers/staging/rtl8192u/r8192U_dm.c
> > +++ b/drivers/staging/rtl8192u/r8192U_dm.c
> > @@ -410,9 +410,9 @@ static void dm_check_rate_adaptive(struct net_device *dev)
> > 
> >  			ratr_value = targetRATR;
> >  			RT_TRACE(COMP_RATE, "currentRATR = %x, targetRATR = %x\n", currentRATR, targetRATR);
> > -			if (priv->rf_type == RF_1T2R) {
> > +			if (priv->rf_type == RF_1T2R)
> >  				ratr_value &= ~(RATE_ALL_OFDM_2SS);
> > -			}
> > +
> but this is just removal of unnecessary braces. this is not removal of redundant code.
and, missed writing in the last mail.
your [PATCH v2 2/4] and [PATCH v2 3/4] are same.

thanks
sudip
> 
<snip>
> >  			write_nic_dword(dev, RATR0, ratr_value);
> >  			write_nic_byte(dev, UFWP, 1);
