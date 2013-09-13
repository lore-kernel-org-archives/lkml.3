Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab3INUz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 16:55:26 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44360 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3INUzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 16:55:25 -0400
Message-ID: <52333646.1020103@gmail.com>
Date: Fri, 13 Sep 2013 08:59:02 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] perf tools: New comm infrastructure
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com> <20130912203658.GA3216@gmail.com> <20130913124354.GB4844@somewhere>
In-Reply-To: <20130913124354.GB4844@somewhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/13 5:43 AM, Frederic Weisbecker wrote:
>   The only way would be perhaps to be able to limit the deepness
> of the callchain branches.

I was thinking about such a feature two days ago. Max callchain depth is 
set to 255 at compile time which can generate huge event sizes. perf 
needs to allow the user to specify max depth for an event at less than that.

David
