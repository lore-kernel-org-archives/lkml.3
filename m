Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaIVPNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:13:16 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63109 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaIVPNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:13:15 -0400
Subject: Re: [PATCH 4/5] perf tools: Introduce perf_callchain_config()
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20140922145109.GF32694@kernel.org>
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
	 <1411229886-24390-5-git-send-email-namhyung@kernel.org>
	 <20140922142510.GE18187@krava.brq.redhat.com>
	 <20140922145109.GF32694@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Sep 2014 00:12:51 +0900
Message-ID: <1411398771.1665.3.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-22 (월), 11:51 -0300, Arnaldo Carvalho de Melo:
> Em Mon, Sep 22, 2014 at 04:25:10PM +0200, Jiri Olsa escreveu:
> > On Sun, Sep 21, 2014 at 01:18:05AM +0900, Namhyung Kim wrote:
> > > +int perf_callchain_config(const char *var, const char *value)
> > > +{
> > > +	if (prefixcmp(var, "call-graph."))
> > > +		return 0;
> > > +	var += 11; /* strlen("call-graph.") == 11 */
>  
> > should we use sizeof("call-graph.") - 1 instead ?
> 
> Agreed, it should produce the same code and is more compact :-)

Will change.

Thanks,
Namhyung



