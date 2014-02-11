Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaBKL2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:28:49 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:49221 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKL2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:28:48 -0500
MIME-Version: 1.0
In-Reply-To: <20140211111421.GN27965@twins.programming.kicks-ass.net>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
	<20140210212955.GC5002@laptop.programming.kicks-ass.net>
	<CABPqkBRzvfcdKGG4yY9q1PmtVL5Z=9H1RzHg8QDMN42a7=AF6A@mail.gmail.com>
	<20140211071401.GG27965@twins.programming.kicks-ass.net>
	<CABPqkBRn+AVUA-KTx-JQ28j1NhE4pDQe5vjb5NKGx0jrZq8g_Q@mail.gmail.com>
	<20140211105217.GS9987@twins.programming.kicks-ass.net>
	<CABPqkBROriDQa5-b-w45zV+2gS94oEW1c_bYwGmYAeYcqPoUog@mail.gmail.com>
	<20140211110242.GU9987@twins.programming.kicks-ass.net>
	<CABPqkBQhUCUOszQzBJZd_pwX-nLf6y=0X-+swPi0pE3ivRpVcg@mail.gmail.com>
	<CABPqkBSbBqOtvstKwQWD7jM8nn3XEdq0OXMjW8Z8oCF17uRYPw@mail.gmail.com>
	<20140211111421.GN27965@twins.programming.kicks-ass.net>
Date: Tue, 11 Feb 2014 12:28:47 +0100
Message-ID: <CABPqkBRw4W9=ORuhAJpx4L0pCt8iBKshhR5Qv5cLvcD5vR2eRA@mail.gmail.com>
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Richard Fowles <fowles@inreach.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 12:14 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Feb 11, 2014 at 12:08:56PM +0100, Stephane Eranian wrote:
>> Assuming you can decode and get the info about the base registers used,
>> you'd have to do this for each arch with load/store sampling capabilities.
>> this is painful compared to getting the portable info from dwarf directly.
>
> But its useful now, as compared to whenever GCC gets around to
> implementing more dwarves and that GCC getting used widely enough to
> actually rely on it.
>
> All you need for the decode is a disassembler, and every arch should
> already have multiple of those. Should be easy to reuse one, right?

I know, and you want to pull this into the perf tool?
