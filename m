Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3IPIB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:01:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:37179 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab3IPIB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:01:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,913,1371106800"; 
   d="scan'208";a="403856027"
Message-ID: <1379318513.17490.64.camel@sauron.fi.intel.com>
Subject: Re: [GIT PULL] UBI changes for 3.12-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Sep 2013 11:01:53 +0300
In-Reply-To: <1379316610.17490.58.camel@sauron.fi.intel.com>
References: <1379316610.17490.58.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 10:30 +0300, Artem Bityutskiy wrote:
> Hi Linus,
> 
> very few changes. I'll start using a single UBI/UBIFS tree instead
> of 2 trees from now on. So in the future you'll get 1 small pull
> request instead of 2 tiny ones.

Also, I do realize this is very late, apologies for this. But the
changes are just small fixes so I they should be OK for -rc2 as well.

-- 
Best Regards,
Artem Bityutskiy

