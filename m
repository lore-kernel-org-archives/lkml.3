Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbbA0O3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:29:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbbA0O3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:29:10 -0500
Date: Tue, 27 Jan 2015 12:29:02 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Jiri Olsa <jolsa@redhat.com>, namhyung@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexey.Brodkin@synopsys.com
Subject: Re: [PATCH v3 0/5] Perf tool fixes for ARC + uClibc
Message-ID: <20150127142902.GB2406@redhat.com>
References: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
 <20150114120000.GB11443@krava.brq.redhat.com>
 <20150114135930.GA2463@redhat.com>
 <54BC897C.7070309@synopsys.com>
 <20150119135843.GA2276@redhat.com>
 <54C768A7.8020505@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C768A7.8020505@synopsys.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 27, 2015 at 03:59:59PM +0530, Vineet Gupta escreveu:
> Hi Arnaldo,
> 
> On Monday 19 January 2015 07:28 PM, Arnaldo Carvalho de Melo wrote:
> >>>>> Acked-by: Jiri Olsa <jolsa@kernel.org>
> >>> > > Most are already in my perf/urgent branch.
> >> > Are you planning to add {4,5}/5 for next window or did u drop/miss them ?
> > I will, IIRC those were not that trivial, so could wait, I'll make sure
> > I review them and merge for perf/core if I find no issues.
> 
> Sorry for annoying pestering on this. I don't see the patches in ur perf/core yet
> and given that we are so close to next window, I fear that we will miss them if we
> don't add them soon.
> 
> We need them to be able to use perf on ARC - fixing build issue (5/5) as well as
> run time issue (4/5)

Applied the remaining ones to my perf/core branch, will be on my next
pull req to Ingo.

- Arnaldo
