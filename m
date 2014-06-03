Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaFCSaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:30:05 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62444 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaFCSaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:30:03 -0400
Date: Tue, 3 Jun 2014 20:29:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf/probe: Fix perf probe to find
 correct variable DIE
Message-ID: <20140603182955.GA7664@gmail.com>
References: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <53872A72.6040007@hitachi.com>
 <20140529134100.GE1177@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529134100.GE1177@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Thu, May 29, 2014 at 09:39:14PM +0900, Masami Hiramatsu wrote:
> > Hi Arnaldo,
> > 
> > Here is the patch which fixes perf probe to find variable
> > location correctly, on the recent dwarf format. This is not
> > related to the SEGV issue which I fixed in previous mail.
> > 
> > Thank you,
> 
> hi,
> I took both patches to my perf/core.. will check
> if Ingo wants the segfault fix via perf/urgent

Yeah, segfaults (or any other random/uncontrolled user space behavior) 
we generally want to fix via perf/urgent. (Please also put a Cc: 
stable@vger.kernel.org tag into it, in case it misses v3.15.)

Thanks,

	Ingo
