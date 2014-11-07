Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaKGPde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:33:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaKGPdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:33:31 -0500
Date: Fri, 7 Nov 2014 13:33:02 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
Message-ID: <20141107153302.GB2137@redhat.com>
References: <20141102105557.21708.19032.stgit@hemant-fedora>
 <87lhnr5sbl.fsf@sejong.aot.lge.com>
 <54588905.7040002@linux.vnet.ibm.com>
 <5458CD15.4010101@hitachi.com>
 <874muew2hk.fsf@sejong.aot.lge.com>
 <5459E865.6050207@hitachi.com>
 <545B1DDE.9000202@linux.vnet.ibm.com>
 <545C80F4.4020905@hitachi.com>
 <20141107084211.GC23531@worktop.programming.kicks-ass.net>
 <545CE239.6050205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545CE239.6050205@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 07, 2014 at 08:16:09AM -0700, David Ahern escreveu:
> On 11/7/14, 1:42 AM, Peter Zijlstra wrote:
> >On Fri, Nov 07, 2014 at 05:21:08PM +0900, Masami Hiramatsu wrote:
> >>The paths of buildid cache of binary/symbols are not changed.
> >
> >Could we get an option in .perfconfig to disable the buildid cache? Its
> >pointless diskspace wastage for some of us.
> 
> I was going to respond with the same. This:
> 
> [buildid]
>    # Default, disable using /dev/null
>    dir = /dev/null
> 
> disables the build-id cache. Hopefully that extends to all the other
> caches getting discussed.

I think this can even be something Kconfig'ed, and we can provide a
.config file for people like Peter that want as barebone a perf he can
get over with :-)

/me needs to try that last perf Kconfig patchkit...

- Arnaldo
