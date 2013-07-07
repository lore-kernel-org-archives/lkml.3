Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3GGNOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 09:14:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab3GGNN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 09:13:57 -0400
Date: Sun, 7 Jul 2013 15:13:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2] perf report/top: Add option to collapse undesired
 parts of call graph
Message-ID: <20130707131340.GA23433@krava.brq.redhat.com>
References: <20130701142841.GE22203@biohazard-cafe.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701142841.GE22203@biohazard-cafe.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 10:28:45AM -0400, Greg Price wrote:
> For example, in an application with an expensive function
> implemented with deeply nested recursive calls, the default
> call-graph presentation is dominated by the different callchains
> within that function.  By ignoring these callees, we can collect
> the callchains leading into the function and compactly identify
> what to blame for expensive calls.

hi,
what's this one based on? I cannot get it applied on acme's perf/core

thanks,
jirka
