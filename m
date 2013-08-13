Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3HMSWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:22:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758021Ab3HMSWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:22:47 -0400
Date: Tue, 13 Aug 2013 20:22:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V10 12/13] perf tools: add a function to calculate sample
 event size
Message-ID: <20130813182210.GB21321@krava.brq.redhat.com>
References: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com>
 <1376045519-13832-13-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376045519-13832-13-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 01:51:58PM +0300, Adrian Hunter wrote:
> Add perf_event__sample_event_size() which can be used when
> synthesizing sample events to determine how big the resulting
> event will be, and therefore how much memory to allocate.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

PERF_SAMPLE_READ code updated..

Acked-by: Jiri Olsa <jolsa@redhat.com>
