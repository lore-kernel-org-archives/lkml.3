Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935540Ab3FTBpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:45:18 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59668 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935477Ab3FTBpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:45:16 -0400
X-AuditID: 9c93017d-b7c6dae000005092-16-51c25eaa73a9
Date: Thu, 20 Jun 2013 10:45:36 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 3/3] perf tools: include termios.h explicitly
Message-ID: <20130620014536.GB13026@lge.com>
References: <1371603750-15053-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com>
 <20130619113326.GA9119@gmail.com>
 <CAM9d7cjpHEoZaMQE_y5+b1+PZvXrAarzrjtd_GHaNgy1ODy0mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cjpHEoZaMQE_y5+b1+PZvXrAarzrjtd_GHaNgy1ODy0mQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 09:16:20PM +0900, Namhyung Kim wrote:
> Hi Ingo,
> 
> On Wed, Jun 19, 2013 at 8:33 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> >
> >> Building perf for android is failed, because it can't find definition of
> >> struct winsize. This definition is in termios.h, so I add this header
> >> to util.h to solve the problem. It is missed by commit '2c803e52' which
> >> moves get_term_dimensions() from builtin-top.c to util.c, but, missed to
> >> move termios.h header.
> >>
> >> Cc: David Ahern <dsahern@gmail.com>
> >> Cc: Namhyung Kim <namhyung@kernel.org>
> >> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > Is this something we need for v3.10 as well?
> >
> > Thanks,
> >
> >         Ingo
> 
> I think it's good to go to v3.10 and even v3.9 as well:
> 
>  $ git name-rev --tags --refs=refs/tags/v3.* 2c803e52
>  2c803e52 tags/v3.9-rc1~173^2~13^2~22

Agreed.

> 
> --
> Thanks,
> Namhyung
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
