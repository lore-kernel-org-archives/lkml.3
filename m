Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaKDHQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:16:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:34440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaKDHQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:16:36 -0500
Date: Tue, 4 Nov 2014 08:16:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V6 01/17] perf, x86: Reduce lbr_sel_map size
Message-ID: <20141104071634.GI15602@worktop.programming.kicks-ass.net>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
 <1413755712-8259-2-git-send-email-kan.liang@intel.com>
 <20141024093930.GD12706@worktop.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077016530FB@SHSMSX103.ccr.corp.intel.com>
 <20141104071421.GD10501@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104071421.GD10501@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:14:21AM +0100, Peter Zijlstra wrote:
> On Tue, Nov 04, 2014 at 01:07:39AM +0000, Liang, Kan wrote:
> > Hi Peter,
> > 
> > Did you get a chance to review the rest of the patch set?
> 
> No point in reviewing stuff I could not apply if I wanted to is there?

So please (re)read Documentation/SubmittingPatches and try again. Also,
you might want to not Cc Zheng on the next posting (but very much leave
him attribution, just not actually send the mail to a dead email
address).
