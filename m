Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3AXJjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:39:36 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:37232 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3AXJjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:39:15 -0500
Date: Thu, 24 Jan 2013 10:39:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH v6 2/2] perf stat: add interval printing
Message-ID: <20130124093907.GA24621@gmail.com>
References: <1358860732-4435-1-git-send-email-eranian@google.com>
 <1358860732-4435-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358860732-4435-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> This patch adds a new printing mode for perf stat.
> It allows internval printing. That means perf stat

s/rnv/rv

> can now print event deltas at regular time interval.
> This is useful to detect phases in programs.
> 
> The -I option enables interval printing. It expects
> an interval duration in milliseconds. Minimum is
> 100ms. Once, activated perf stat prints events deltas
> since last printout. All modes are supported.
> 
> $ perf stat -I 1000 -e cycles noploop 10
> noploop for 10 seconds
>  #           time             counts events
>       1.000109853      2,388,560,546 cycles
>       2.000262846      2,393,332,358 cycles
>       3.000354131      2,393,176,537 cycles
>       4.000439503      2,393,203,790 cycles
>       5.000527075      2,393,167,675 cycles
>       6.000609052      2,393,203,670 cycles
>       7.000691082      2,393,175,678 cycles

Looks useful!

Thanks,

	Ingo
