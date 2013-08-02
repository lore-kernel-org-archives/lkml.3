Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3HBRKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:10:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:37760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab3HBRKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:10:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="380892094"
Message-ID: <51FBE807.6040907@intel.com>
Date: Fri, 02 Aug 2013 10:10:31 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, bp@suse.de, dave@linux.vnet.ibm.com
Subject: Re: [PATCH resend] drop_caches: add some documentation and info message
References: <1375459442.8422.1@driftwood>
In-Reply-To: <1375459442.8422.1@driftwood>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 09:04 AM, Rob Landley wrote:
> I'd be surprised if anybody who does this sees the printk and thinks
> "hey, I'll dig into the VM's balancing logic and come up to speed on the
> tradeoffs sufficient to contribute to kernel development" because of
> something in dmesg. Anybody actually annoyed by it will chop out the
> printk (you barely need to know C to do that), the rest won't notice.

All that I expect is that this will get _some_ of these folks in to a
feedback loop with us.  They'll see this in dmesg and either go asking
questions within their respective companies, file bugs with distros, or
post to LKML.

Some of them are going to say things like "My Database Vendor told me
this optimizes my server!", or that the documentation told them to do it
so they don't run out of memory.  Some of them might even be running in
to _legitimate_ VM or filesystem bugs that they're working around with this.


