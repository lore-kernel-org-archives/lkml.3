Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab3JGWMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3JGWMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:12:41 -0400
Date: Tue, 8 Oct 2013 00:12:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 37/50] tools/perf/build: Improve printout-of
 auto-detected features
Message-ID: <20131007221233.GF2900@krava.redhat.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-38-git-send-email-mingo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381147003-2574-38-git-send-email-mingo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 01:56:30PM +0200, Ingo Molnar wrote:

SNIP

> +#
> +# Only print out our features if we rebuilt the testcases or if a test failed:
> +#
> +ifeq ($(test-all-failed), 1)
> +  $(foreach feat,$(CORE_FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
> +  $(info )
> +endif

found the DUMMY! what do I win? ;-)

jirka
