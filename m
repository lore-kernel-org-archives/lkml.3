Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaK1O00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:26:26 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35187 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaK1O0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:26:24 -0500
Date: Fri, 28 Nov 2014 15:26:21 +0100
From: Luis de Bethencourt <luis@debethencourt.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, aaro.koskinen@iki.fi,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, eunb.song@samsung.com
Subject: Re: [PATCH v2] staging: octeon: Fix checkpatch warnings
Message-ID: <20141128142621.GA8571@ks395439.kimsufi.com>
References: <20141127161432.GA32577@ks395439.kimsufi.com>
 <20141128102928.GD4860@mwanda>
 <20141128133034.GA4635@ks395439.kimsufi.com>
 <20141128141432.GG4860@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128141432.GG4860@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 05:14:32PM +0300, Dan Carpenter wrote:
> On Fri, Nov 28, 2014 at 02:30:34PM +0100, Luis de Bethencourt wrote:
> > On Fri, Nov 28, 2014 at 01:29:28PM +0300, Dan Carpenter wrote:
> > > On Thu, Nov 27, 2014 at 05:18:10PM +0100, Luis de Bethencourt wrote:
> > > > Fixing 80 character limit warnings in octeon/ethernet-rx.c
> > > > 
> > > > Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
> > > > ---
> > > >  drivers/staging/octeon/ethernet-rx.c | 51 +++++++++++++++++++++++++-----------
> > > >  1 file changed, 35 insertions(+), 16 deletions(-)
> > > > 
> > > > diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> > > > index 1789a12..e387eb1 100644
> > > > --- a/drivers/staging/octeon/ethernet-rx.c
> > > > +++ b/drivers/staging/octeon/ethernet-rx.c
> > > > @@ -109,6 +109,7 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
> > > >  		int interface = cvmx_helper_get_interface_num(work->ipprt);
> > > >  		int index = cvmx_helper_get_interface_index_num(work->ipprt);
> > > >  		union cvmx_gmxx_rxx_frm_ctl gmxx_rxx_frm_ctl;
> > > > +
> > > 
> > > Do this in a separate patch.
> > 
> > Will do within the hour.
> > 
> 
> :(  You should always wait overnight or a few hours before sending a
> patch.  It's not a race.  Go slowly.
> 
> regards,
> dan carpenter
> 

Is the wait so people have more time to review the patch as it is?
I wanted to show my interest by keeping up with reviews but now that you
mention that, it makes sense.

I screwed up and didn't submit the version 3 of this patch with [01/02] for the
character limit warnings. Will wait, since the patch for the empty lines after
variable declarations needs to be applied on-top of this. I will wait until that
one is accepted or rejected before rebasing and submitting the second patch.

Sorry about this.

Thanks for all the help :)

Luis
