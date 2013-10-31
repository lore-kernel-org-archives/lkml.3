Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3JaIuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:50:37 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45270 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3JaIuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:50:35 -0400
Date: Thu, 31 Oct 2013 09:50:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/2] tools/perf/build: Fix detection of non-core features
Message-ID: <20131031085031.GB8992@gmail.com>
References: <1383064996-20933-1-git-send-email-dsahern@gmail.com>
 <20131029172903.GF7737@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029172903.GF7737@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Oct 29, 2013 at 10:43:15AM -0600, David Ahern wrote:
> > feature_check needs to be invoked through call, and LDFLAGS may not be set
> > so quotes are needed.
> 
> and the problem is also when there's more than one option in LDFLAGS

yeah.

> > Thanks to Jiri for spotting the quotes around LDFLAGS; that one was driving
> > me nuts with the upcoming timerfd feature detection.
> > 
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> 
> Reviewed-and-tested-by: Jiri Olsa <jolsa@redhat.com>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
