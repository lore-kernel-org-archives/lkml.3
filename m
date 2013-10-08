Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3JHPVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:21:12 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57505 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3JHPVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:21:11 -0400
Message-ID: <525422E2.9010401@gmail.com>
Date: Tue, 08 Oct 2013 09:21:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 18/52] tools/perf/build: Split out feature check: 'libunwind'
References: <1381227082-22039-1-git-send-email-mingo@kernel.org> <1381227082-22039-19-git-send-email-mingo@kernel.org>
In-Reply-To: <1381227082-22039-19-git-send-email-mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/13 4:10 AM, Ingo Molnar wrote:
> @@ -240,15 +241,7 @@ ifneq ($(ARCH),x86)
>   endif
>
>   ifndef NO_LIBUNWIND
> -  # for linking with debug library, run like:
> -  # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
> -  ifdef LIBUNWIND_DIR
> -    LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
> -    LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
> -  endif

You are dropping the above so add-on libunwind support will break.

David
