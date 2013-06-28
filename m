Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3F1J5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:57:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3F1J5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:57:08 -0400
Date: Fri, 28 Jun 2013 11:56:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 06/15] perf tools: fix parse_events_terms() freeing
 local variable on error path
Message-ID: <20130628095633.GB28751@krava.brq.redhat.com>
References: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
 <1372409006-8431-7-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372409006-8431-7-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 11:43:17AM +0300, Adrian Hunter wrote:
> The list_head is on the stack, so just free the rest of the list.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
