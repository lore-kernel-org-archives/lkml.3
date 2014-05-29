Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbaE2NlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:41:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932646AbaE2NlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:41:13 -0400
Date: Thu, 29 May 2014 15:41:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf/probe: Fix perf probe to find
 correct variable DIE
Message-ID: <20140529134100.GE1177@krava.brq.redhat.com>
References: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <53872A72.6040007@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53872A72.6040007@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 09:39:14PM +0900, Masami Hiramatsu wrote:
> Hi Arnaldo,
> 
> Here is the patch which fixes perf probe to find variable
> location correctly, on the recent dwarf format. This is not
> related to the SEGV issue which I fixed in previous mail.
> 
> Thank you,

hi,
I took both patches to my perf/core.. will check
if Ingo wants the segfault fix via perf/urgent

thanks,
jirka
