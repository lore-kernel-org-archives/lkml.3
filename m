Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbaGILtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:49:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678AbaGILtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:49:23 -0400
Date: Wed, 9 Jul 2014 13:49:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]  perf script: Add callchain to generic and
 tracepoint events
Message-ID: <20140709114903.GA5767@krava.redhat.com>
References: <53031D2C.2050009@tu-dresden.de>
 <20140307141857.GA3153@ghostprotocols.net>
 <533D2283.3090703@tu-dresden.de>
 <87wqd5f7j5.fsf@sejong.aot.lge.com>
 <538F0BF2.1010806@tu-dresden.de>
 <20140707171706.GA20752@krava.redhat.com>
 <53BCF1F2.70100@tu-dresden.de>
 <20140709112721.GC1814@krava.redhat.com>
 <53BD2AD6.6020309@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD2AD6.6020309@tu-dresden.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 01:43:18PM +0200, Joseph Schuchart wrote:
> Jirka,
> 
> I tried to apply the patches to the latest version of the perf/core branch before sending. Can you please send me some more information about the conflict?

is your HEAD 8b5b584 ?

[jolsa@krava perf]$ git show --oneline tip/perf/core
8b5b584 Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core

jirka

