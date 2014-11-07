Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaKGImT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:42:19 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGImR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:42:17 -0500
Date: Fri, 7 Nov 2014 09:42:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        oleg@redhat.com, hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
Message-ID: <20141107084211.GC23531@worktop.programming.kicks-ass.net>
References: <20141102105006.21708.28734.stgit@hemant-fedora>
 <20141102105557.21708.19032.stgit@hemant-fedora>
 <87lhnr5sbl.fsf@sejong.aot.lge.com>
 <54588905.7040002@linux.vnet.ibm.com>
 <5458CD15.4010101@hitachi.com>
 <874muew2hk.fsf@sejong.aot.lge.com>
 <5459E865.6050207@hitachi.com>
 <545B1DDE.9000202@linux.vnet.ibm.com>
 <545C80F4.4020905@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545C80F4.4020905@hitachi.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 05:21:08PM +0900, Masami Hiramatsu wrote:
> The paths of buildid cache of binary/symbols are not changed.

Could we get an option in .perfconfig to disable the buildid cache? Its
pointless diskspace wastage for some of us.
