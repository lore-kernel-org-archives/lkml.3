Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3JLTm6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 15:42:58 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50951 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3JLTm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 15:42:57 -0400
Message-ID: <5259A63B.5050406@gmail.com>
Date: Sat, 12 Oct 2013 13:42:51 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org> <20131011055829.GA4975@gmail.com> <20131011073448.GA11064@krava.redhat.com> <52581511.2010909@gmail.com> <52581737.8090309@gmail.com> <20131012165319.GB15116@gmail.com>
In-Reply-To: <20131012165319.GB15116@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/13 10:53 AM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> On 10/11/13 9:11 AM, David Ahern wrote:
>>> It would be nice to fix the callchain arg handler to not attempt to
>>> process the next argument if it is not fp or dwarf.
>>
>> Specifically, something like this which maintains syntax and default
>> fp option:
>
> Lets not maintain a broken syntax please - breaking the very simple -ga
> was the primary regression to begin with, so lets fix that.

I think I did with the second follow up patch: -ga -ag -g fp -g dwarf 
should all work properly with fp the default for -g.

David

