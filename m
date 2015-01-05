Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbbAEN6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:58:08 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbbAEN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:58:06 -0500
Date: Mon, 5 Jan 2015 14:57:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, "acme@kernel.org" <acme@kernel.org>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: Re: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Message-ID: <20150105135748.GT30905@twins.programming.kicks-ass.net>
References: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
 <20141204142330.GB10406@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F0770167D124@shsmsx102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770167D124@shsmsx102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 02:49:52PM +0000, Liang, Kan wrote:
> > I'll test it once I get hands on Haswel server again, I guess we wait for the
> > kernel change to go in first anyway, right?
> >
> 
> I'm not sure, let's ask Peter.
> 
> Peter?

Ok so only 3/3 was missing right? I handed the kernel bits to Ingo when
I 'left' with a note that userspace was pending. It seems that is now
resolved.

I stuck 3/3 at the end (it seems to still apply -- yay!) and will send
it together with the kernel bits.
