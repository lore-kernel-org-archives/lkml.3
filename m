Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3AVOad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:30:33 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43307 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3AVOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:30:26 -0500
MIME-Version: 1.0
In-Reply-To: <20130118230040.GI4051@tassilo.jf.intel.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
	<1358264386-24633-6-git-send-email-eranian@google.com>
	<20130118230040.GI4051@tassilo.jf.intel.com>
Date: Tue, 22 Jan 2013 15:30:25 +0100
Message-ID: <CABPqkBTqY-mf0JgWarfvJ6cRhDPOM1eEODScGXOM-mExX04SiA@mail.gmail.com>
Subject: Re: [PATCH v6 05/18] perf: add minimal support for PERF_SAMPLE_WEIGHT
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 12:00 AM, Andi Kleen <ak@linux.intel.com> wrote:
> On Tue, Jan 15, 2013 at 04:39:33PM +0100, Stephane Eranian wrote:
>> Ensure we grab the weight from  raw sample struct
>> and that we can dump it via perf report -D.
>
> AFAIK i have a similar patch in the haswell patchkit.
>
> It's straight forward of course, just have to chose one.
> I think mine does slightly more.
>
Yes, mine is a tiny subset of yours. Should use yours instead.
Will swap with yours if that's easy to do.
