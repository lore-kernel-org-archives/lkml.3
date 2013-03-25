Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3CYITb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:19:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:54771 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821Ab3CYIT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208";a="275499637"
Date: Mon, 25 Mar 2013 01:19:28 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Michael Neuling <mikey@neuling.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        x86@kernel.org
Subject: Re: [PATCH 01/29] tsx: Add generic noop macros for RTM intrinsics
Message-ID: <20130325081928.GT19692@tassilo.jf.intel.com>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
 <1364001923-10796-2-git-send-email-andi@firstfloor.org>
 <30418.1364182745@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30418.1364182745@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> RTM == restricted transactional memory.  I don't understand why it's
> "restricted" and why any other architecture else would call it that and

It's restricted as in there is no guarantee that a transaction ever succeeds
and always needs a fallback path. My understanding is that this is true for 
PPC too, but not necessarily zSeries.

> hence why Linux should call it that?
> 
> Can we just call it TM for transactional memory?  Each arch can then
> have their own implementation and call it what they want.

I don't think the name will stop them to do anything.

If people feel strongly about it can change it, but it's not
actually making a real difference.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
