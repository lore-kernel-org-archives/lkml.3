Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbaGUQdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:33:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:46159 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbaGUQdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,702,1400050800"; 
   d="scan'208";a="576528735"
From: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
	<53CCB6AE.6020505@intel.com> <20140721080219.GA4183@krava.redhat.com>
	<53CCD3A7.5070002@intel.com> <20140721095415.GB8865@krava.redhat.com>
5ATo: Jiri Olsa <jolsa@redhat.com>
Date: Mon, 21 Jul 2014 09:31:41 -0700
In-Reply-To: <20140721095415.GB8865@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 21 Jul 2014 11:54:15 +0200")
Message-ID: <87d2cy3c7m.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:
>
> [jolsa@ibm-x3650m4-01 perf]$ sudo ./perf report --stdio
> Timestamp below last timeslice flush
> 0x2276f58 [0x68]: failed to process type: 9

FWIW we're seeing this frequently too.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
