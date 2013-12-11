Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3LKUHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:07:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:56437 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab3LKUHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:07:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,873,1378882800"; 
   d="scan'208";a="450742440"
Date: Wed, 11 Dec 2013 12:07:21 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 21/71] perf tools: Add feature test for
 __sync_val_compare_and_swap
Message-ID: <20131211200721.GN22695@tassilo.jf.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-22-git-send-email-alexander.shishkin@linux.intel.com>
 <20131211192407.GD1458@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211192407.GD1458@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you provide more info about these gcc builtins and what is the
> minimum system where this test will succeed?

CMPXCHG for x86 is available since the 486 or so, so practically
everywhere.

I think that's mainly for other architectures.

it would be reasonable to just use #if defined(__x86_64__) || defined(__i386__)
instead.

-Andi
