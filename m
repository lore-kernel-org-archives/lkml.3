Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaLDPvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:51:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:48098 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbaLDPvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:51:49 -0500
Date: Thu, 4 Dec 2014 12:51:42 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: Re: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Message-ID: <20141204155142.GD18689@kernel.org>
References: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
 <20141204142330.GB10406@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F0770167D124@shsmsx102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770167D124@shsmsx102.ccr.corp.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 04, 2014 at 02:49:52PM +0000, Liang, Kan escreveu:
> Jiri Wrote:
> > looks ok to me..
 
> Thanks for the review.
 
> > I'll test it once I get hands on Haswel server again, I guess we wait for the
> > kernel change to go in first anyway, right?
 
> I'm not sure, let's ask Peter.
 
> Peter?

Would be good to go in one pull request, so that whoever pulls it has
the chance to test the kernel feature with the accompanying tooling bits.

- Arnaldo
