Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaAKTa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:30:59 -0500
Received: from one.firstfloor.org ([193.170.194.197]:51379 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaAKTa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:30:56 -0500
Date: Sat, 11 Jan 2014 20:30:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, eranian@google.com,
        fweisbec@gmail.com, mingo@kernel.org, adrian.hunter@intel.com,
        dsahern@gmail.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] perf, tools: Add support for prepending LBRs to
 the callstack
Message-ID: <20140111193054.GL20765@two.firstfloor.org>
References: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
 <20140111153614.GC1131@krava.brq.redhat.com>
 <20140111175816.GK20765@two.firstfloor.org>
 <20140111191657.GB17659@ghostprotocols.net>
 <20140111191846.GC17659@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111191846.GC17659@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What was your build command line?
> 
> Here, on a f18 system it works with these:
> 
> $ make -C tools/perf O=/tmp/build/perf install
> 
> $ cd tools/perf ; make
> 
> Trying on another system...

Sorry for the false alarm. It looks like it was a problem on my side.
Works now.

-andi
