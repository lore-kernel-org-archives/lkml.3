Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaGGRRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaGGRRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:17:21 -0400
Date: Mon, 7 Jul 2014 19:17:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Add callchain to generic and tracepoint events.
Message-ID: <20140707171706.GA20752@krava.redhat.com>
References: <53031D2C.2050009@tu-dresden.de>
 <20140307141857.GA3153@ghostprotocols.net>
 <533D2283.3090703@tu-dresden.de>
 <87wqd5f7j5.fsf@sejong.aot.lge.com>
 <538F0BF2.1010806@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F0BF2.1010806@tu-dresden.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 02:07:14PM +0200, Joseph Schuchart wrote:
> Add callchain to generic and tracepoint events.
> Since this alters the interface for the python scripts, 
> also adjust the script generation and the provided scripts.

hi,
I might be out of track in here, since I wasn't CC-ed,
but I've got to this patchset as a dependency for perf
CTF perf script so I need it ;-) however..

I just tried to apply it and got some conflicts in patch 2/3.

Could you please rebase to the latest tip/perf/core and resend
the whole set? Also prefix your subjects with 'perf script:'

Arnaldo,
not sure if you are tracking these.. please let me know

thanks,
jirka
