Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3JIGpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:45:10 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:60530 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3JIGpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:45:07 -0400
Date: Wed, 9 Oct 2013 08:45:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 18/52] tools/perf/build: Split out feature check:
 'libunwind'
Message-ID: <20131009064503.GA20857@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-19-git-send-email-mingo@kernel.org>
 <525422E2.9010401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525422E2.9010401@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 10/8/13 4:10 AM, Ingo Molnar wrote:
> >@@ -240,15 +241,7 @@ ifneq ($(ARCH),x86)
> >  endif
> >
> >  ifndef NO_LIBUNWIND
> >-  # for linking with debug library, run like:
> >-  # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
> >-  ifdef LIBUNWIND_DIR
> >-    LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
> >-    LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
> >-  endif
> 
> You are dropping the above so add-on libunwind support will break.

Oops - restored it.

Thanks,

	Ingo
