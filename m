Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaHLO2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:28:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbaHLO2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:28:47 -0400
Date: Tue, 12 Aug 2014 16:28:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Archana Patni <archana.patni@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] HID: hid-sensor-hub: use devm_ functions consistently
In-Reply-To: <53DD7A5F.4000204@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1408121628090.15220@pobox.suse.cz>
References: <20140802221135.GA18239@himangi-Dell> <53DD7A5F.4000204@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2014, Srinivas Pandruvada wrote:

> > Use devm_kzalloc for all calls to kzalloc and not just the first.  Use
> > devm functions for other allocations as well. The calls to free the
> > allocated memory in the probe and remove functions are done away with
> > and a label is removed in the probe function.
> > 
> > The semantic match that finds the inconsistency is as follows:
> > 
> > // <smpl>
> > @@
> > @@
> > 
> > *devm_kzalloc(...)
> > ...
> > *kzalloc(...)
> > // </smpl>
> > 
> > Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> > Acked-by: Julia Lawall <julia.lawall@lip6.fr>
>  Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>

Queued for 3.17, thanks.

-- 
Jiri Kosina
SUSE Labs
