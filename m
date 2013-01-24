Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3AXSos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:44:48 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:65284 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3AXSoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:44:44 -0500
Message-ID: <51018118.10800@gmail.com>
Date: Thu, 24 Jan 2013 11:44:40 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Tom Zanussi <tom.zanussi@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] perf tools: some 'perf script' fixes
References: <cover.1358527965.git.tom.zanussi@linux.intel.com> <20130124182736.GA14382@infradead.org>
In-Reply-To: <20130124182736.GA14382@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/13 11:27 AM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 18, 2013 at 01:51:24PM -0600, Tom Zanussi escreveu:
>> This patchset fixes various problems I hit while doing a run-through
>> of the existing 'perf script' scripts.
>>
>> Also, sometimes when running rwtop I get a 'failed to read event
>> header' error, which this patch fixes:
>>
>> https://lkml.org/lkml/2012/9/14/401
>>
>> Not sure if that was meant to get picked up, but it fixed that
>> particular problem here for me.
>
> David, can you please resubmit it with an explanation in the commit
> message?

As part of other perf related activities I have noticed that readn is 
used in some places that we will want it to return immediately -- e.g., 
evsel.c. So, this might not be the proper fix for all use cases.

David


