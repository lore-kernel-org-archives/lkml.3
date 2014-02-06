Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaBFPYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:24:09 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56406 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaBFPYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:24:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140206140936.GC26955@infradead.org>
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
	<20140206135627.GA26955@infradead.org>
	<CABPqkBS5qLDYyyv=n8fT4K+hA3uRWYmQOZmO+n-UE9=X=cEFzQ@mail.gmail.com>
	<20140206140705.GB26955@infradead.org>
	<20140206140936.GC26955@infradead.org>
Date: Thu, 6 Feb 2014 16:24:07 +0100
Message-ID: <CABPqkBRwy=0pnmm657TwV25GiYbpkqC1E8+cUGLEUbqxO=Gusw@mail.gmail.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 3:09 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Thu, Feb 06, 2014 at 12:07:05PM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Thu, Feb 06, 2014 at 02:58:01PM +0100, Stephane Eranian escreveu:
>> > On Thu, Feb 6, 2014 at 2:56 PM, Arnaldo Carvalho de Melo
>> > <acme@redhat.com> wrote:
>> > > Em Wed, Feb 05, 2014 at 10:25:09PM +0100, Stephane Eranian escreveu:
>> > >> If you run perf top on 3.14 but you force --stdio mode, perf top
>> > >> goes crazy and constantly refreshes the output.
>>
>> > >> It does that with many older versions of the perf as well on 3.14.
>> > >> It runs fine with newt mode.
>>
>> > >> Works fine with my 3.11 kernel. So something must be broken
>> > >> with 3.14.
>>
>> > >> Can you reproduce the problem as well?
>>
>> > > Not so far, using my perf/urgent branch:
>>
>> > I am using tip.git. Or try 3.11, 3.10.
>
> But my tests are on top of:
>
> [acme@ssdandy linux]$ uname -r
> 3.11.4-101.fc18.x86_64
>
> I thought it was a 3.14ish one, building one to try there...
>
The kernel must be 3.14-rcX, the tool can be any version.

> - Arnaldo
