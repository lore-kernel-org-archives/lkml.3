Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaKGPVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:21:23 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59170 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKGPVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:21:22 -0500
Message-ID: <545CE36C.7040906@gmail.com>
Date: Fri, 07 Nov 2014 08:21:16 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms
 on NO_LIBELF=1
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/14, 10:20 PM, Namhyung Kim wrote:
> It worked w/o libelf, but recent change to use vmlinux for kernel
> symbols break it.

Do you know the recent change (commit id) that broke it?

David
