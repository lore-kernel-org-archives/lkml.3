Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaIZXDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:03:21 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55303 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaIZXDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:03:19 -0400
Date: Fri, 26 Sep 2014 16:03:14 -0700
From: josh@joshtriplett.org
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>,
        tapaswenipathak@gmail.com, opw-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <error27@gmail.com>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [OPW kernel] checkpatch: Does anyone care that comments are
 freeform aligned?
Message-ID: <20140926230314.GN20632@cloud>
References: <alpine.DEB.2.02.1409240745160.2051@localhost6.localdomain6>
 <1411584074.3594.17.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411584074.3594.17.camel@joe-AO725>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:41:14AM -0700, Joe Perches wrote:
> On Wed, 2014-09-24 at 07:47 +0200, Julia Lawall wrote:
> > In the following patch extract, one line is indented with spaces rather 
> > than tabs.  Is it intentional that checkpatch doesn't complain about this, 
> > I guess due to the line being a comment?
> []
> >  struct bcm_hdr_suppression_contextinfo {
> > -	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS]; /* Intermediate buffer to accumulate pkt Header for PHS */
> > -	UCHAR ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN]; /* Intermediate buffer containing pkt Header after PHS */
> > +    /* Intermediate buffer to accumulate pkt Header for PHS */
> > +	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS];
> > +	/* Intermediate buffer containing pkt Header after PHS */
> > +	UCHAR ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN];
> >  };
> 
> checkpatch does not care when comments start in any
> particular position or ensure comments have tabs
> preceding them.
> 
> Does anyone care?

This should have already been caught by other whitespace checks that
check for indentations of 8 or more spaces.  Similarly, mixed tab/space
indentations would get caught by those same checks.  I don't think
checkpatch needs to check those.

- Josh Triplett
