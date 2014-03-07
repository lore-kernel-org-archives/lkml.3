Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaCGRRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:17:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:30712 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbaCGRRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:17:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,608,1389772800"; 
   d="scan'208";a="494279612"
From: Andi Kleen <andi@firstfloor.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 5/5][RFC][CFT] resizable namespace.c hashes
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
	<20140305035219.GE26528@ZenIV.linux.org.uk>
Date: Fri, 07 Mar 2014 09:17:19 -0800
In-Reply-To: <20140305035219.GE26528@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 5 Mar 2014 03:52:19 +0000")
Message-ID: <87bnxi6i8w.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> * switch allocation to alloc_large_system_hash()
> * make sizes overridable by boot parameters (mhash_entries=, mphash_entries=)
> * switch mountpoint_hashtable from list_head to hlist_head

So how much memory does this use on a standard system (<4GB memory)?
How much memory does it use on a large system (0.5TB)?

How good is your hash function. Would jhash be more appropiate
and allow smaller hash tables?

Perhaps just want a tree here.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
