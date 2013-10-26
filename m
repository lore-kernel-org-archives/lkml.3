Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3JZOdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 10:33:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab3JZOdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 10:33:01 -0400
Date: Sat, 26 Oct 2013 16:32:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 0/4] perf tools: Fix -g option handling
Message-ID: <20131026143231.GB1069@krava.brq.redhat.com>
References: <20131026120336.GA24439@gmail.com>
 <1382797536-32303-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382797536-32303-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 04:25:32PM +0200, Jiri Olsa wrote:
> hi,
> changing the '-g/-G' options for record/top commands
> to take NO argument and enable unwind method based
> on .perfconfig setup (using FP by default).
> 
> The current -g option parsing moves into the
> '--call-graph' option.

forgot to mention branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/cc

jirka
