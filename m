Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaIVOvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:51:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:34130 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbaIVOvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:51:14 -0400
Date: Mon, 22 Sep 2014 11:51:09 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] perf tools: Introduce perf_callchain_config()
Message-ID: <20140922145109.GF32694@kernel.org>
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
 <1411229886-24390-5-git-send-email-namhyung@kernel.org>
 <20140922142510.GE18187@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922142510.GE18187@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 22, 2014 at 04:25:10PM +0200, Jiri Olsa escreveu:
> On Sun, Sep 21, 2014 at 01:18:05AM +0900, Namhyung Kim wrote:
> > +int perf_callchain_config(const char *var, const char *value)
> > +{
> > +	if (prefixcmp(var, "call-graph."))
> > +		return 0;
> > +	var += 11; /* strlen("call-graph.") == 11 */
 
> should we use sizeof("call-graph.") - 1 instead ?

Agreed, it should produce the same code and is more compact :-)

- Arnaldo
