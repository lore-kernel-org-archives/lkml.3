Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab3KREsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 23:48:09 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41899 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3KREsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 23:48:00 -0500
Message-ID: <52899BFF.5080007@gmail.com>
Date: Sun, 17 Nov 2013 21:47:59 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCH 3/3] perf script: Print mmap[2] events also
References: <1384743642-15120-1-git-send-email-namhyung@kernel.org> <1384743642-15120-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1384743642-15120-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/13, 8:00 PM, Namhyung Kim wrote:
> If --show-mmap option is given, also print internal MMAP and MMAP2
> events.  It would be helpful for debugging.
>
> Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Outside of the free following a strdup, the 3 patches looked good to me. 
Procrastination worked in my favor. Once these go in I'll do the move to 
perf-dump.

For all 3:
Reviewed-by: David Ahern <dsahern@gmail.com>

