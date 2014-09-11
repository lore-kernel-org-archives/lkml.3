Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbaIKPxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:53:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:56896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138AbaIKPxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:53:07 -0400
Date: Thu, 11 Sep 2014 17:53:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: mingo@redhat.com, mingo@kernel.com, dzickus@redhat.com, bmr@redhat.com,
        jcastillo@redhat.com, oleg@redhat.com, pzijlstr@redhat.com,
        riel@redhat.com, prarit@redhat.com, jgh@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        akpm@google.com, linuxppc-dev@lists.ozlabs.org, minchan@kernel.org
Subject: Re: [PATCH v3 0/3] sched: Always check the integrity of the canary
Message-ID: <20140911155303.GI4783@worktop.ger.corp.intel.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
 <1410450088-18236-1-git-send-email-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410450088-18236-1-git-send-email-atomlin@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


What's with the threading all versions together? Please don't do that --
also don't post a new version just for this though.
