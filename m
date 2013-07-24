Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab3GXNM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3GXNM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:12:57 -0400
Date: Wed, 24 Jul 2013 15:12:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V8 15/15] perf tools: add a sample parsing test
Message-ID: <20130724131215.GC4203@krava.brq.redhat.com>
References: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
 <1374144177-24762-16-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374144177-24762-16-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 01:42:57PM +0300, Adrian Hunter wrote:
> Add a test that checks that sample parsing is correctly
> implemented.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
