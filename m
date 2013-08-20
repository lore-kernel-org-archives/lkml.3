Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab3HTQW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:22:59 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51555 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3HTQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:22:58 -0400
Message-ID: <521397DE.5010306@gmail.com>
Date: Tue, 20 Aug 2013 10:22:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: Make command line arguments consistent with
 perf-record
References: <1377010076-21509-1-git-send-email-dsahern@gmail.com> <20130820145156.GC8488@ghostprotocols.net>
In-Reply-To: <20130820145156.GC8488@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/13 8:51 AM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Aug 20, 2013 at 08:47:56AM -0600, David Ahern escreveu:
>> Common arguments like thread id, CPU list, mmap pages, etc should be
>> consistent across perf commands.
>
>
>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> ---
>>   tools/perf/builtin-trace.c |   12 ++++++------
>
>   tools/perf/Documentation/perf-trace.txt part missing :-)


grrrr... Added a check in the git pre-commit hook to remind me:

$ git commit -a
changing command line arguments. Did you update the man page?

Will resend later today.
David
