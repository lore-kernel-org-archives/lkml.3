Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab3JTA3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 20:29:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:25307 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3JTA3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 20:29:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,531,1378882800"; 
   d="scan'208";a="419537184"
From: Andi Kleen <andi@firstfloor.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 2/4] perf: streamline append_chain() function
References: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com>
	<1382107129-2010-3-git-send-email-Waiman.Long@hp.com>
Date: Sat, 19 Oct 2013 17:29:18 -0700
In-Reply-To: <1382107129-2010-3-git-send-email-Waiman.Long@hp.com> (Waiman
	Long's message of "Fri, 18 Oct 2013 10:38:47 -0400")
Message-ID: <87ppr0u6n5.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Waiman Long <Waiman.Long@hp.com> writes:

> as well as
> using ?: statement which can be more efficient than the regular if
> statement in some architectures.

I don't think that's true, the compiler does if conversion anyways for both.

But change seems reasonable.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
