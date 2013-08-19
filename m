Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab3HSRGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:06:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58108 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750968Ab3HSRGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:06:50 -0400
Message-ID: <1376932008.26430.2.camel@joe-AO722>
Subject: Re: [PATCH] [trivial]treewide: Fix typo in printk
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Aug 2013 10:06:48 -0700
In-Reply-To: <52124EB3.6000103@infradead.org>
References: <1376885430-9606-1-git-send-email-standby24x7@gmail.com>
	 <52124EB3.6000103@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 09:58 -0700, Randy Dunlap wrote:
> On 08/18/13 21:10, Masanari Iida wrote:
> > Correct spelling typo in printk.
> > Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
[]
> > diff --git a/drivers/infiniband/ulp/isert/Kconfig b/drivers/infiniband/ulp/isert/Kconfig
[]
> > @@ -1,5 +1,5 @@
> >  config INFINIBAND_ISERT
> > -	tristate "iSCSI Extentions for RDMA (iSER) target support"
> > +	tristate "iSCSI Extensions for RDMA (iSER) target support"
> >  	depends on INET && INFINIBAND_ADDR_TRANS && TARGET_CORE && ISCSI_TARGET
> >  	---help---
> >  	Support for iSCSI Extentions for RDMA (iSER) Target on Infiniband fabrics.

This isn't printk and there's another "iSCSI Extentions"
use below the ---help---

So fix one, fix all?


