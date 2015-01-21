Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbbAUVpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:45:24 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41720 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbAUVpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:45:17 -0500
Message-ID: <54C01E14.8020906@gmail.com>
Date: Wed, 21 Jan 2015 14:45:56 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 20/36] perf build: Add arch x86 objects building
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org> <1421771973-6022-21-git-send-email-jolsa@kernel.org> <54C0177C.3060703@gmail.com> <20150121213157.GH6835@krava.brq.redhat.com>
In-Reply-To: <20150121213157.GH6835@krava.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/15 2:31 PM, Jiri Olsa wrote:
> the thing is that in arch/Build we now do:
>
> +libperf-y += $(ARCH)/
>
> which would make the build to fail on other architectures,
> because the build framework requires 'Build' file in
> nested directories.. and this patch adds it only for x86

ok. perhaps add that to the commit message.

David
