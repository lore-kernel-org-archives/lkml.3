Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaGWNVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:21:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaGWNVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:21:16 -0400
Date: Wed, 23 Jul 2014 15:20:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 17/52] perf evlist: Add
 perf_evlist__set_tracking_event()
Message-ID: <20140723132046.GC17252@krava.brq.redhat.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-18-git-send-email-adrian.hunter@intel.com>
 <20140722192206.GD29750@krava.redhat.com>
 <53CF5559.8050908@intel.com>
 <53CF95BE.7060909@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CF95BE.7060909@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 02:00:14PM +0300, Adrian Hunter wrote:
> Add a function to change which event is used
> to track mmap, comm and task events.
> 
> This is needed with Instruction Tracing
> because the Instruction Tracing event
> must come first but cannot be used for
> tracking because it will be disabled
> under some circumstances.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
