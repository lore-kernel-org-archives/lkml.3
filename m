Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaJNVII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:08:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:45255 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbaJNVIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:08:06 -0400
Date: Tue, 14 Oct 2014 18:08:02 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/5] perf tools: Speed up dwarf callchain
 post-unwinding for libunwind (v4)
Message-ID: <20141014210802.GJ3198@kernel.org>
References: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
 <20141013181158.GA28191@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013181158.GA28191@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 13, 2014 at 08:11:58PM +0200, Jiri Olsa escreveu:
> On Mon, Oct 06, 2014 at 09:45:58AM +0900, Namhyung Kim wrote:
> > Namhyung Kim (5):
> >   perf report: Set callchain_param.record_mode for future use
> >   perf callchain: Create an address space per thread
> >   perf callchain: Use global caching provided by libunwind
> >   perf kvm: Use thread_{,_set}_priv helpers
> >   perf trace: Use thread_{,_set}_priv helpers
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Ok, will merge/test/put it in my next patchkit,

- Arnaldo
