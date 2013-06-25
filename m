Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3FYOBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:01:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3FYOBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:01:44 -0400
Date: Tue, 25 Jun 2013 16:01:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/15] perf tools: add debug prints
Message-ID: <20130625140107.GK23329@krava.brq.redhat.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
 <1372079772-20803-11-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372079772-20803-11-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 04:16:07PM +0300, Adrian Hunter wrote:
> It is useful to see the arguments to perf_event_open
> and whether the perf events ring buffer was mmapped
> per-cpu or per-thread.  That information will now be
> displayed when verbose is 2 i.e option -vv
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

got some fuzz when applying, anyway

Acked-by: Jiri Olsa <jolsa@redhat.com>
