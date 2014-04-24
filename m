Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaDXLfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:35:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbaDXLfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:35:06 -0400
Date: Thu, 24 Apr 2014 13:34:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 00/11] perf tools: Fixup for the --percentage change
 (v3)
Message-ID: <20140424113438.GB1110@krava.brq.redhat.com>
References: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 05:23:52PM +0900, Namhyung Kim wrote:

SNIP

> 
> So yes, it has a same problem of inaccurate number of samples, but its
> impact should be smaller than other stats - seeing increasing sample
> count (could be slightly inaccurate) without new entries in the browser.
> 
>  * changes in v3)
>   - split patch 2/7 into parts  (Jiri)
>   - fix a segfault when filtering with unfolded entry  (Jiri)

other than my comment for patch 4 it seems ok to me

thanks,
jirka
