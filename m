Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaHLTBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:01:40 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48033 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaHLTBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:01:38 -0400
Message-ID: <53EA6495.4010600@gmail.com>
Date: Tue, 12 Aug 2014 13:01:41 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCH 1/2] perf top: Fix -z option behavior
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/14, 2:16 AM, Namhyung Kim wrote:
> The current -z option does almost nothing.  It doesn't zero the
> existing samples so that we can see profiles of exited process after
> last refresh.  It seems it only affects annotation.
>
> This patch clears existing entries before processing if -z option is
> given.  For this original decaying logic also moved before processing.

This option was broken somewhere recently. I am on vacation for another 
week, so I can't do a git bisect myself but I recall it worked a year or 
so ago. Try v3.4 as a start point.

David
