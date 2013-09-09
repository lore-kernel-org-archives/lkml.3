Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3IILSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:18:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48264 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3IILSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:18:01 -0400
Date: Mon, 9 Sep 2013 13:17:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
Message-ID: <20130909111749.GP31370@twins.programming.kicks-ass.net>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 12:36:11PM +0200, Jiri Olsa wrote:
> hi,
> sending the support for multiple file storage. Initial
> RFC is here:
> http://marc.info/?l=linux-kernel&m=137408381902423&w=2
> 
> v2 changes:
>   - reworked perf mmap size setup to be able to get
>     the mmap size value easily later
>   - added perf.data read/write test for v2 and v3
>     for both endianity
>   - added record '-M time' support

So this 0/n post seems to have forgotten to list the rationale for doing
all this.. 

The only reason I wanted this is so that each thread can write its own
data. The current one file thing is an immense bottle-neck for big
machines.

However your earlier patches didn't do it because of that -- I forgot
why they did it and you're now not telling.


