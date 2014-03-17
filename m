Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbaCQHRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:17:46 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56616 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaCQHRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:17:45 -0400
X-AuditID: 9c93017d-b7c89ae000006ae1-2d-5326a1972dd4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/5] perf tools: Add machine pointer into thread struct
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
	<1394805606-25883-5-git-send-email-jolsa@redhat.com>
	<20140314141612.GE2396@ghostprotocols.net>
Date: Mon, 17 Mar 2014 16:17:43 +0900
In-Reply-To: <20140314141612.GE2396@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Fri, 14 Mar 2014 11:16:12 -0300")
Message-ID: <878us9tht4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Fri, 14 Mar 2014 11:16:12 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Mar 14, 2014 at 03:00:05PM +0100, Jiri Olsa escreveu:
>> Need machine pointer in thread object, so we could
>> lookup the process thread in following patch.
>
> Can't we use the already existing thread->mg.machine for that?

It needs to know the machine when ->mg is not allocated yet.

That means we can now get rid of the mg->machine?

Thanks,
Namhyung
