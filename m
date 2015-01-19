Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbbASN6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:58:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbbASN6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:58:49 -0500
Date: Mon, 19 Jan 2015 11:58:43 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Jiri Olsa <jolsa@redhat.com>, namhyung@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexey.Brodkin@synopsys.com
Subject: Re: [PATCH v3 0/5] Perf tool fixes for ARC + uClibc
Message-ID: <20150119135843.GA2276@redhat.com>
References: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
 <20150114120000.GB11443@krava.brq.redhat.com>
 <20150114135930.GA2463@redhat.com>
 <54BC897C.7070309@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BC897C.7070309@synopsys.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 19, 2015 at 10:05:08AM +0530, Vineet Gupta escreveu:
> Hi Arnaldo,
> 
> On Wednesday 14 January 2015 07:29 PM, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Jan 14, 2015 at 01:00:00PM +0100, Jiri Olsa escreveu:
> >> > On Tue, Jan 13, 2015 at 07:13:19PM +0530, Vineet Gupta wrote:
> >>> > > Hi,
> >>> > > 
> >>> > > This series based off linux-next of 20150105 allows us to build/use perf
> >>> > > for ARC with uClibc based userland.
> >>> > > 
> >>> > > v3: Changes since v2 [2]
> >>> > > * 1/5	: Ack from Jiri
> >>> > > * 2/5	: no changes
> >>> > > * 3/5	: sys/syscall.h included	  [Jiri]
> >>> > > * 4/5	: no changes
> >>> > > * 5/5	: -lpthread added to link target  [Jiri]
> >>> > > * {1,5} : Changelog updated so scissor lines don't start at column 1

> >> > Acked-by: Jiri Olsa <jolsa@kernel.org>
> > Most are already in my perf/urgent branch.

> Are you planning to add {4,5}/5 for next window or did u drop/miss them ?

I will, IIRC those were not that trivial, so could wait, I'll make sure
I review them and merge for perf/core if I find no issues.

- Arnaldo
