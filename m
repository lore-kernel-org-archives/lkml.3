Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbaEGOtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:49:10 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45773 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEGOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:49:09 -0400
Message-ID: <536A47E0.4080206@gmail.com>
Date: Wed, 07 May 2014 08:49:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf tools: Use tid for finding thread
References: <1399429566-15587-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1399429566-15587-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/14, 8:26 PM, Namhyung Kim wrote:
> I believe that passing pid (instead of tid) as the 3rd arg of the
> machine__find*_thread() was to find a main thread so that it can
> search proper map group for symbols.  However with the map sharing
> patch applied, it now can do it in any thread.
>
> It fixes a bug when each thread has different name, it only reports a
> main thread for samples in other threads.
>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: David Ahern <dsahern@gmail.com>

