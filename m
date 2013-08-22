Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3HVOlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:41:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:23483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab3HVOlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,934,1367996400"; 
   d="scan'208";a="384942570"
Date: Thu, 22 Aug 2013 22:41:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com, jack@suse.cz,
        dev@parallels.com, miklos@szeredi.hu, fuse-devel@lists.sourceforge.net,
        xemul@parallels.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, linux-mm@kvack.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, devel@openvz.org, mgorman@suse.de
Subject: Re: [PATCH] mm: strictlimit feature -v4
Message-ID: <20130822144121.GA620@localhost>
References: <20130821135427.20334.79477.stgit@maximpc.sw.ru>
 <20130821133804.87ca602dd864df712e67342a@linux-foundation.org>
 <5215E4B7.3020003@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5215E4B7.3020003@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxim,

> >I think I'll apply it to -mm for now to get a bit of testing, but would
> >very much like it if Fengguang could find time to review the
> >implementation, please.
> Great! Fengguang, please...

I'm so sorry for the delays!

I'd like to test the patches out and take a look at its runtime
behaviors. I've managed to setup general dd writeback tests. Do you
happen to have some scripts that can specifically test out the fuse
cases?

Thanks,
Fengguang
