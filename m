Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab3HGNo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:44:27 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:47058 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3HGNo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:44:26 -0400
Message-ID: <52024F38.4080808@gmail.com>
Date: Wed, 07 Aug 2013 09:44:24 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 01/17] perf util: Save pid-cmdline mapping into tracing
 header
References: <1375175954-798-1-git-send-email-namhyung@kernel.org> <1375175954-798-2-git-send-email-namhyung@kernel.org> <20130730132839.GA2607@ghostprotocols.net> <51F85FAA.2090400@lge.com> <20130731140746.GA3614@ghostprotocols.net> <87r4e81u8w.fsf@sejong.aot.lge.com>
In-Reply-To: <87r4e81u8w.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/13 3:17 AM, Namhyung Kim wrote:
>> I don't think this is a problem, its in line with Ingo's suggestion of a
>> new perf ioctl to ask the kernel to generate PERF_RECORD_MMAP events for
>> existing threads.
>
> Hmm.. could you please give me a link of the thread?

I believe this is the thread being referred to:
https://lkml.org/lkml/2013/6/25/180

David
