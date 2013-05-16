Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3EPN3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:29:13 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53966 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab3EPN3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:29:08 -0400
Message-ID: <5194DF20.3010300@gmail.com>
Date: Thu, 16 May 2013 07:29:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC/PATCH 1/2] perf script: Add --time-filter option
References: <1368609839-19899-1-git-send-email-namhyung@kernel.org> <5193A6E7.9040501@gmail.com> <87sj1n4rh3.fsf@sejong.aot.lge.com> <51944796.7020505@gmail.com> <8738tn48c5.fsf@sejong.aot.lge.com>
In-Reply-To: <8738tn48c5.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/13 2:50 AM, Namhyung Kim wrote:
> On Wed, 15 May 2013 20:42:30 -0600, David Ahern wrote:
>> On 5/15/13 7:56 PM, Namhyung Kim wrote:
>>>> How about just --time? less typing.
>>>
>>> Thanks, I'm fine with '--time' too but '--time-filter' looks more
>>
>> yes, I just have really long command lines now. Is there a consistent
>> single letter (X?)?
>
> Do you mean a single-letter option "-X" for this?

Yes, by consistent I meant a letter not used by any of the current 
analysis commands (report, script, diff). We are to the point where 
options are getting added only as --some-name now. Be nice to have 
single letter shortcuts.

David

