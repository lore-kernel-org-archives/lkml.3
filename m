Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697Ab3DBD7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:59:16 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55073 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760131Ab3DBD7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:59:14 -0400
X-AuditID: 9c93016f-b7b6aae000000e9c-12-515a579050f7
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/27] perf tools: Move programs check into config/Makefile
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
	<1364843930-17974-5-git-send-email-jolsa@redhat.com>
	<1364854190.1728.12.camel@leonhard>
	<20130401222703.GC20943@krava.redhat.com>
Date: Tue, 02 Apr 2013 12:59:12 +0900
In-Reply-To: <20130401222703.GC20943@krava.redhat.com> (Jiri Olsa's message of
	"Tue, 2 Apr 2013 00:27:03 +0200")
Message-ID: <87sj39fur3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013 00:27:03 +0200, Jiri Olsa wrote:
> On Tue, Apr 02, 2013 at 07:09:50AM +0900, Namhyung Kim wrote:
>> 2013-04-01 (월), 21:18 +0200, Jiri Olsa:
>> > Moving programs check into config/Makefile.
>> 
>> [SNIP]
>> 
>> > +RM      = rm -f
>> > +MKDIR   = mkdir
>> > +FIND    = find
>> > +INSTALL = install
>> > +FLEX    = flex
>> > +BISON   = bison
>> > +STRIP  ?= strip
>> 
>> Why does STRIP use "?=" form?
>> 
>> I know you just moved the line, but AFAICS it can be converted to a
>> normal variable assignment, right?
>
> not sure, I guess someone found usefull to use custom strip 

AFAIK one can override those variables on a cmdline even if it's set via
normal variable assignment.

Thanks,
Namhyung
