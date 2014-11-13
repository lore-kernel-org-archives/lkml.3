Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaKMSsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:48:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:60121 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbaKMSsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:48:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="416122545"
Date: Thu, 13 Nov 2014 10:48:10 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: kan.liang@intel.com, acme@kernel.org, a.p.zijlstra@chello.nl,
        eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org
Subject: Re: [PATCH V2 2/3] perf tool: re-organize
 thread__resolve_callchain_sample
Message-ID: <20141113184810.GC4358@tassilo.jf.intel.com>
References: <1415837895-10275-1-git-send-email-kan.liang@intel.com>
 <1415837895-10275-3-git-send-email-kan.liang@intel.com>
 <20141113182123.GA6309@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113182123.GA6309@krava.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any chance you guys could sync on this? ..you're touching the
> same code.. Andi, maybe you wouldn't mind having this patch
> instead of your change.. looks like the only extra part is the
> cpumode resolve.

Please just merge one of them, and the other can rebase.

Note the lbr as callgraph has been posted since nearly a year now
(v1 was in January)

If you merged patches faster all these problems with conflicts
wouldn't happen.

-Andi
