Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaHVIDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:03:18 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55423 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaHVIDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:03:13 -0400
Date: Fri, 22 Aug 2014 10:03:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/2] perf hists browser: Cleanup callchain routines
 (v2)
Message-ID: <20140822080308.GC7714@gmail.com>
References: <1408583746-5540-1-git-send-email-namhyung@kernel.org>
 <20140821081117.GA4777@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821081117.GA4777@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Thu, Aug 21, 2014 at 10:15:44AM +0900, Namhyung Kim wrote:
> > Hello,
> > 
> > This patch fixes and cleans up TUI callchain routines.  I tried to
> > consolidate similar functions but not to break the current output with
> > this change.  Hope that it makes code more readable and maintainable.
> 
> 76 insertions(+), 134 deletions(-) ... nice! ;-)
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Indeed, very nice!

	Ingo
