Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaKJODd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:03:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:58490 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaKJODb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:03:31 -0500
Date: Mon, 10 Nov 2014 15:03:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V8 00/14] perf, x86: Haswell LBR call stack support
 (kernel)
Message-ID: <20141110140323.GH29390@twins.programming.kicks-ass.net>
References: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
 <20141110101327.GG3337@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770165E272@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770165E272@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 01:54:03PM +0000, Liang, Kan wrote:
> 
> Yes, Zheng's patches are exact same patches as you already had. I only
> remove 11, 13,16, 17 from previous patch set and add your new patch (no
> change). 

OK thanks for confirming, I didn't find any changes, but that could
equally be because I didn't look ahrd enough ;-)

> The significant changes are in user tool part, I sent them out as
> a separate patch set.

Right, saw those, picked them up while asking acme/jolsa for an ack.

Thanks!
