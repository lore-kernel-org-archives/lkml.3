Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaHUPZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:25:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:39439 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaHUPZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:25:20 -0400
Date: Thu, 21 Aug 2014 12:25:15 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/2] perf hists browser: Cleanup callchain routines
 (v2)
Message-ID: <20140821152515.GK2892@kernel.org>
References: <1408583746-5540-1-git-send-email-namhyung@kernel.org>
 <20140821081117.GA4777@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821081117.GA4777@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 21, 2014 at 10:11:17AM +0200, Jiri Olsa escreveu:
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

indeed :-)

- Arnaldo
