Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3LCOaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:30:14 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36263 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3LCOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:30:09 -0500
Message-ID: <529DEAEE.6020708@gmail.com>
Date: Tue, 03 Dec 2013 07:30:06 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 1/3] perf tools: Record total sampling time
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>	<1385967199-3759-2-git-send-email-namhyung@kernel.org>	<20131202124527.GB22212@gmail.com> <20131202125709.GA22404@gmail.com>	<1385999009.1710.72.camel@leonhard> <20131202163620.GC27781@gmail.com>	<20131202202459.GF17149@ghostprotocols.net> <87y542mqts.fsf@sejong.aot.lge.com>
In-Reply-To: <87y542mqts.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/13, 10:44 PM, Namhyung Kim wrote:
>> Right now 'perf stat -i' i used for '--no-inherit', perhaps we can just
>> have --no-inherit have no short option and grab -i to have the same
>> meaning as in 'report', 'script', etc.
>
> Agreed.  Maybe we could change it to plain --inherit.

yes: https://lkml.org/lkml/2013/11/19/330

David

