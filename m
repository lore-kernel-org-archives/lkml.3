Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3IAL2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 07:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375Ab3IAL16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 07:27:58 -0400
Date: Sun, 1 Sep 2013 13:27:42 +0200
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
Subject: Re: [PATCH V2 3/3] perf tools: add 'keep tracking' test
Message-ID: <20130901112742.GB1063@krava.brq.redhat.com>
References: <1377975053-3811-1-git-send-email-adrian.hunter@intel.com>
 <1377975053-3811-4-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377975053-3811-4-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 09:50:53PM +0300, Adrian Hunter wrote:
> Add a test for the newly added PERF_COUNT_SW_DUMMY event.
> The test checks that tracking events continue when an
> event is disabled but a dummy software event is not
> disabled.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Tested/Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
