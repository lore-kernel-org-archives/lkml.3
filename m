Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3JGVTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:19:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab3JGVTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:19:12 -0400
Date: Mon, 7 Oct 2013 23:18:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 26/50] tools/perf/build: Split out feature check: 'libbfd'
Message-ID: <20131007211858.GB2900@krava.redhat.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-27-git-send-email-mingo@kernel.org>
 <5252CF13.3040200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5252CF13.3040200@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 09:11:15AM -0600, David Ahern wrote:
> On 10/7/13 5:56 AM, Ingo Molnar wrote:
> >diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> >index 77a2e6b..4f60ecc 100644
> >--- a/tools/perf/config/Makefile
> >+++ b/tools/perf/config/Makefile
> >@@ -121,6 +121,7 @@ FEATURE_TESTS =				\
> >  	libperl				\
> >  	libpython			\
> >  	libpython-version		\
> >+	libbfd				\
> >  	libnuma
> >
> >  $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
> 
> strlcpy missing from FEATURE_TESTS, but really the strlcpy changes
> should be a separate patch.

it gets removed completely in here:
  tools/perf: Turn strlcpy() into a __weak function

still I think David's right and there should be
separate patch for strlcpy check

jirka
