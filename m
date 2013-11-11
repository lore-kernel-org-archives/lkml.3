Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3KKPRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:17:43 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37141 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab3KKPRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:17:38 -0500
Message-ID: <5280F50E.6010700@gmail.com>
Date: Mon, 11 Nov 2013 08:17:34 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf record: mmap output file - v4
References: <1383884605-30968-1-git-send-email-dsahern@gmail.com> <1383884605-30968-3-git-send-email-dsahern@gmail.com> <20131111112906.GE15810@gmail.com> <20131111145804.GB27198@ghostprotocols.net>
In-Reply-To: <20131111145804.GB27198@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13, 7:58 AM, Arnaldo Carvalho de Melo wrote:
>
>> Looks very clean now!
>
>> Acked-by: Ingo Molnar <mingo@kernel.org>
>
> Applied the prep patch, but waiting for v5 as stated by David when
> answering Jiri's concerns.

I'll re-send - giving some time for comments on the use of 
setjmp/longjmp to bounce out of memcpy and error exit when filesystem 
runs out of space.

David
