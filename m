Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaDZTyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 15:54:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29861 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaDZTyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 15:54:39 -0400
Date: Sat, 26 Apr 2014 22:52:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Del Piano <ndel314@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mail@berndporr.me.uk
Subject: Re: [rfc PATCH] checkpatch: allow multiple const * types
Message-ID: <20140426194208.GG4963@mwanda>
References: <5359DF54.50607@gmail.com>
 <20140425075020.GF26890@mwanda>
 <1398482999.3071.8.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398482999.3071.8.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 08:29:59PM -0700, Joe Perches wrote:
> On Fri, 2014-04-25 at 10:50 +0300, Dan Carpenter wrote:
> > On Fri, Apr 25, 2014 at 01:06:44AM -0300, Nicolas Del Piano wrote:
> > > diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
> []
> > > @@ -439,6 +439,7 @@ static void *comedi_recognize(struct comedi_driver *driv, const char *name)
> > >  static void comedi_report_boards(struct comedi_driver *driv)
> > >  {
> > >  	unsigned int i;
> > > +
> > >  	const char *const *name_ptr;
> > 
> > The original code was correct.  This is a bug in checkpatch.pl.  The
> > missing line check should count any lines starting with "const" or
> > "static" as declarations.
> 
> Right, thanks for the report.
> 
> I'm not around for a couple weeks.
> I'll fix it properly later.

No stress.  These are not a big deal.  These false positives are rare,
there is no way we would have applied the patch and even if we did then
the extra blank line is harmless.

regards,
dan carpenter

