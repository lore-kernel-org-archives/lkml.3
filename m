Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3IRNfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:35:38 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:56925 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3IRNfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:35:37 -0400
Date: Wed, 18 Sep 2013 15:35:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [RFC] Full syscall argument decode in "perf trace"
Message-ID: <20130918133525.GB8141@gmail.com>
References: <20130917190606.GB3918@infradead.org>
 <52398FF1.5020502@redhat.com>
 <5239A0BE.7050203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5239A0BE.7050203@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 9/18/13 5:35 AM, Denys Vlasenko wrote:
> >Therefore my question should be restated as:
> >
> >Would perf developers accept the "syscall pausing" feature,
> >or it won't be accepted?
> 
> I have been using perf-trace a lot lately specifically because it is 
> effectively a 'passive' observer of the task (e.g., time-sensitive tasks 
> can be traced with perf but not with strace).

Yes, this is not just an important but a primary design goal for all perf 
utilities: if the tracing buffers used are large enough then it should be 
a nearly zero-overhead observer that preserves all previous patterns of 
behavior as much as possible.

Thanks,

	Ingo
