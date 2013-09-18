Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3IRMrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:47:04 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42177 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3IRMrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:47:02 -0400
Message-ID: <5239A0BE.7050203@gmail.com>
Date: Wed, 18 Sep 2013 06:46:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [RFC] Full syscall argument decode in "perf trace"
References: <20130917190606.GB3918@infradead.org> <52398FF1.5020502@redhat.com>
In-Reply-To: <52398FF1.5020502@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/13 5:35 AM, Denys Vlasenko wrote:
> Therefore my question should be restated as:
>
> Would perf developers accept the "syscall pausing" feature,
> or it won't be accepted?

I have been using perf-trace a lot lately specifically because it is 
effectively a 'passive' observer of the task (e.g., time-sensitive tasks 
can be traced with perf but not with strace).

Also, your solution would not work if the raw_syscall events are written 
to a file for later analysis where as using tracepoints to collect this 
information would.

David
