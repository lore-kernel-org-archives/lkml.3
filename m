Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3JTUrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 16:47:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab3JTUrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 16:47:21 -0400
Date: Sun, 20 Oct 2013 22:47:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 06/19] perf session: Add missing members to
 perf_event__attr_swap()
Message-ID: <20131020204707.GG12044@krava>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
 <1382099356-4918-7-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382099356-4918-7-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 03:29:03PM +0300, Adrian Hunter wrote:
> perf_event__attr_swap() needs to swap all members of
> struct perf_event_attr.  Add mssing ones.

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
