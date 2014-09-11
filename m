Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaIKQC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:02:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbaIKQCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:02:25 -0400
Date: Thu, 11 Sep 2014 16:59:48 +0100
From: Aaron Tomlin <atomlin@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, mingo@kernel.com, dzickus@redhat.com, bmr@redhat.com,
        jcastillo@redhat.com, oleg@redhat.com, pzijlstr@redhat.com,
        riel@redhat.com, prarit@redhat.com, jgh@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        akpm@google.com, linuxppc-dev@lists.ozlabs.org, minchan@kernel.org
Subject: Re: [PATCH v3 0/3] sched: Always check the integrity of the canary
Message-ID: <20140911155948.GF12612@atomlin.usersys.redhat.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
 <1410450088-18236-1-git-send-email-atomlin@redhat.com>
 <20140911155303.GI4783@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140911155303.GI4783@worktop.ger.corp.intel.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 05:53:03PM +0200, Peter Zijlstra wrote:
> 
> What's with the threading all versions together? Please don't do that --
> also don't post a new version just for this though.

Sorry about that. Noted.

-- 
Aaron Tomlin
