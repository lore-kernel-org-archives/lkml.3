Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab3G3JSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:18:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758385Ab3G3JSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:18:43 -0400
Date: Tue, 30 Jul 2013 11:18:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/8] pktcdvd: More neatenings
In-Reply-To: <1374540811.2061.87.camel@joe-AO722>
Message-ID: <alpine.LNX.2.00.1307301118080.18809@pobox.suse.cz>
References: <20130603125057.GB23987@mwanda>  <cover.1370276576.git.joe@perches.com> <1374540811.2061.87.camel@joe-AO722>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Joe Perches wrote:

> > V3:
> > Fixed patch 2 thinko in sense_string via Dan Carpenter
> > Moved pr_err in patch 5 to avoid moving again in patch 6 via Andy Schevchenko
> > 
> > V2:
> > Removed the compile error the patch 1 and compile fix in 2
> > Added Andy's suggestion in patch 2.
> > Added conversions to print pd->name in logging macros.
> > 
> > Joe Perches (8):
> >   pktcdvd: Convert ZONE macro to static function get_zone()
> >   pktcdvd: Convert printk to pr_<level>
> >   pktcdvd: Consolidate DPRINTK and VPRINTK macros
> >   pktcdvd: Add struct pktcdvd_device * to pkt_dbg
> >   pktcdvd: Add struct pktcdvd_device.name to pr_err logging where possible
> >   pktcdvd: Convert pr_notice to pkt_notice
> >   pktcdvd: Convert pr_info to pkt_info
> >   pktcdvd: Add struct pktcdvd_device * to pkt_dump_sense()
> > 
> >  drivers/block/pktcdvd.c | 278 ++++++++++++++++++++++++------------------------
> >  1 file changed, 140 insertions(+), 138 deletions(-)
> 
> Ping?
> 
> Jiri, are you doing to do anything with this?

This is now in my linux-block.git, I just haven't sent pull request to 
Jens yet. The patchset is scheduled for 3.12.

Thanks,

-- 
Jiri Kosina
SUSE Labs
