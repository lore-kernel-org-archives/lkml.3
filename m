Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab3J2R3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab3J2R3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:29:16 -0400
Date: Tue, 29 Oct 2013 18:29:03 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/2] tools/perf/build: Fix detection of non-core features
Message-ID: <20131029172903.GF7737@krava.brq.redhat.com>
References: <1383064996-20933-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383064996-20933-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:43:15AM -0600, David Ahern wrote:
> feature_check needs to be invoked through call, and LDFLAGS may not be set
> so quotes are needed.

and the problem is also when there's more than one option in LDFLAGS

> 
> Thanks to Jiri for spotting the quotes around LDFLAGS; that one was driving
> me nuts with the upcoming timerfd feature detection.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>

Reviewed-and-tested-by: Jiri Olsa <jolsa@redhat.com>

jirka
