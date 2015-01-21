Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbbAUVRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:17:21 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43421 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbbAUVRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:17:09 -0500
Message-ID: <54C0177C.3060703@gmail.com>
Date: Wed, 21 Jan 2015 14:17:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 20/36] perf build: Add arch x86 objects building
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org> <1421771973-6022-21-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-21-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/15 9:39 AM, Jiri Olsa wrote:
> ---
>   tools/perf/arch/Build           |  1 +
>   tools/perf/arch/arm/Build       |  0
>   tools/perf/arch/arm64/Build     |  0
>   tools/perf/arch/powerpc/Build   |  0
>   tools/perf/arch/s390/Build      |  0
>   tools/perf/arch/sh/Build        |  0
>   tools/perf/arch/sparc/Build     |  0
>   tools/perf/arch/x86/Build       |  2 ++
>   tools/perf/arch/x86/Makefile    | 15 ---------------
>   tools/perf/arch/x86/tests/Build |  2 ++
>   tools/perf/arch/x86/util/Build  |  8 ++++++++
>   11 files changed, 13 insertions(+), 15 deletions(-)
>   create mode 100644 tools/perf/arch/arm/Build
>   create mode 100644 tools/perf/arch/arm64/Build
>   create mode 100644 tools/perf/arch/powerpc/Build
>   create mode 100644 tools/perf/arch/s390/Build
>   create mode 100644 tools/perf/arch/sh/Build
>   create mode 100644 tools/perf/arch/sparc/Build
>   create mode 100644 tools/perf/arch/x86/Build
>   create mode 100644 tools/perf/arch/x86/tests/Build
>   create mode 100644 tools/perf/arch/x86/util/Build

Since this is an x86 patch only the x86 Build files should be added here 
with the others added in respective arch patches.

David

