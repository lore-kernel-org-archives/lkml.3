Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaHUILs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:11:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbaHUILq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:11:46 -0400
Date: Thu, 21 Aug 2014 10:11:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/2] perf hists browser: Cleanup callchain routines
 (v2)
Message-ID: <20140821081117.GA4777@krava.brq.redhat.com>
References: <1408583746-5540-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408583746-5540-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 10:15:44AM +0900, Namhyung Kim wrote:
> Hello,
> 
> This patch fixes and cleans up TUI callchain routines.  I tried to
> consolidate similar functions but not to break the current output with
> this change.  Hope that it makes code more readable and maintainable.

76 insertions(+), 134 deletions(-) ... nice! ;-)

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka
