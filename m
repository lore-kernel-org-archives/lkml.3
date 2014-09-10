Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaIJH3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:29:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48383 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaIJH3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:29:45 -0400
Date: Wed, 10 Sep 2014 09:29:35 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH] checkpatch: struct of_device_id should usually be const
Message-ID: <20140910072935.GA3755@pengutronix.de>
References: <1410333346-29062-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1410333797.24028.29.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410333797.24028.29.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 12:23:17AM -0700, Joe Perches wrote:
> On Wed, 2014-09-10 at 09:15 +0200, Uwe Kleine-König wrote:
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -4941,6 +4941,7 @@ sub process {
> >  				mtrr_ops|
> >  				neigh_ops|
> >  				nlmsvc_binding|
> > +				of_device_id|
> >  				pci_raw_ops|
> >  				pipe_buf_operations|
> >  				platform_hibernation_ops|
> 
> Fine by me, there are ~1200 or so const uses.
> 
> There are also ~350 of these that are not const.
> 
> Are most all of those supposed to be const?
Yeah, I'm working on a patch series to fix most of these. I thought I
sent out the checkpatch patch first to slow down the occurences to fix.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
