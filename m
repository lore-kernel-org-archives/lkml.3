Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaGaOiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:38:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:50810 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaGaOiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:38:13 -0400
Date: Thu, 31 Jul 2014 11:38:08 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Subject: Re: [PATCH v2 1/2] perf tools: Fix make PYTHON override
Message-ID: <20140731143808.GA20547@kernel.org>
References: <1406617040-26909-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406617040-26909-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 29, 2014 at 03:57:19PM +0900, Namhyung Kim escreveu:
> Thomas reported that make PYTHON=python2 is not work on some systems.
> I can reproduce it on my ArchLinux box too.
> 
> This is because it's overridden by config/feature-checks/Makefile
> regardless of PYTHON setting.  I guess it's a bug slipped into during
> the feature checking change.
> 
> Actually, we don't need to check python-config in the feature-checks.
> We can just pass appropriate FEATURE_CHECK_*FLAGS.
> 
> Reported-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Thanks, both patches applied.

- Arnaldo
