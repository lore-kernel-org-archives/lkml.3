Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaEOVW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:22:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:51812 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbaEOVWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:22:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1062,1389772800"; 
   d="scan'208";a="539867575"
Date: Thu, 15 May 2014 14:22:52 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, acme@ghostprotocols.net,
        jolsa@redhat.com, jmario@redhat.com
Subject: Re: [PATCH v2]: fix Haswell precise store data source encoding
Message-ID: <20140515212252.GC19657@tassilo.jf.intel.com>
References: <20140515155644.GA3884@quad>
 <20140515195655.GG50500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515195655.GG50500@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Looking at the SDM documentation it does say something about
> 'UOPS_RETIRED.ALL' supporting stores too but can't find that event.  Is
> that a typo, much like the 0x02 umask for stores on the D0 event is
> missing from the documentation?  Just wanted to make sure we are not
> missing one more case.

There are some problems in the HSW perf PEBS list.
I posted a patch for this, but so far it's stuck in the usual
perf patch limbo:

http://lkml.iu.edu/hypermail/linux/kernel/1404.2/01509.html

-Andi

