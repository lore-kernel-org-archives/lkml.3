Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3JJHDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:03:23 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:55917 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3JJHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:03:22 -0400
Date: Thu, 10 Oct 2013 09:03:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 07/52] tools/perf/build: Split out feature check:
 'volatile-register-var'
Message-ID: <20131010070318.GG10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-8-git-send-email-mingo@kernel.org>
 <87d2ndk6tu.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2ndk6tu.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> > +test-volatile-register-var:
> > +	$(BUILD) -Werror -Wvolatile-register-var
> 
> I'm not sure this test is necessary at all.
> 
> The gcc manpage says this warning is enabled by -Wall, and we add -Wall 
> to CFLAGS before doing feature checks.  So all gcc versions that support 
> -Wvolatile-register-var enables it by default without this check and 
> older gcc versions will always fail the feature check.

Good point - I'll send a patch to remove it.

Thanks,

	Ingo
