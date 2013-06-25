Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3FYRDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:03:04 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33582 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3FYRDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:03:02 -0400
Message-ID: <51C9CD41.20402@gmail.com>
Date: Tue, 25 Jun 2013 11:02:57 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/5] perf tools: Fix -x/--exclude-other option for report
 command
References: <1372161253-22081-1-git-send-email-jolsa@redhat.com> <1372161253-22081-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1372161253-22081-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/13 5:54 AM, Jiri Olsa wrote:
> Currently we have symbol_conf.exclude_other being set as true
> every time so the -x/--exclude-other has nothing to do. Also
> we have no way to see the data with symbol_conf.exclude_other
> being false which is useful sometimes.

I'm fine with the change, but wanted to address the "have no way" 
comment: --no-exclude-other should set it to false.

David

