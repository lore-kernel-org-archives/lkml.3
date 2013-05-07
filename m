Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab3EGIgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:36:09 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39856
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758470Ab3EGIgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:36:07 -0400
Date: Tue, 7 May 2013 10:34:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 0/2] perf: Fix/factor auxiliary events
Message-ID: <20130507083417.GA9688@dyad.programming.kicks-ass.net>
References: <1367857638-27631-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367857638-27631-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 06:27:16PM +0200, Jiri Olsa wrote:
> hi,
> sending fix for issue caused by using smp_processor_id()
> in preemptible path discussed in here:
> http://marc.info/?l=linux-kernel&m=136733569907888&w=2
> 
> I also noticed there's a space for some code factoring
> saving some .text size and centralizing auxiliary
> events notification.

These look good, thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
