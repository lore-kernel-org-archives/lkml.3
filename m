Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419AbaGPOZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:25:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbaGPOZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:25:40 -0400
Date: Wed, 16 Jul 2014 16:25:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 20/41] perf tools: Let a user specify a PMU event without
 any config terms
Message-ID: <20140716142510.GE9441@krava.redhat.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-21-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405332185-4050-21-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 01:02:44PM +0300, Adrian Hunter wrote:
> This enables a PMU event to be specified in the form:
> 
> 	pmu//
> 
> which is effectively the same as:
> 
> 	pmu/config=0/
> 
> This patch is a precursor to defining
> default config for a PMU.

I understand the need for default config, but could you please elaborate
why do we want to parse 'pmu//' as an event string string?

thanks,
jirka
