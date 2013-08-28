Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3H1NJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:09:43 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:47968 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3H1NJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:09:41 -0400
Message-ID: <521DF691.7080706@gmail.com>
Date: Wed, 28 Aug 2013 07:09:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf trace: Add option to analyze events in a file
 versus live
References: <1377575535-43544-1-git-send-email-dsahern@gmail.com> <1377575535-43544-3-git-send-email-dsahern@gmail.com> <20130828130258.GC31260@ghostprotocols.net>
In-Reply-To: <20130828130258.GC31260@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/13 7:02 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 26, 2013 at 09:52:14PM -0600, David Ahern escreveu:
>> Allows capture of raw_syscall:* events and analyzed at a later
>> time.
>>
>> +-r
>> +--replay
>> +	Process events from a given perf data file.
>
> Shouldn't this be just -i/--input, like for 'report', 'annotate', etc?
>
> - Arnaldo
>

uh, arguably. But -i == inherit per a prior patch. record (-i = inherit) 
/ report (-i = input file) collision.

I have used this a bit over the last 2 days and -r is not logical. How 
about -f / --file?

David
