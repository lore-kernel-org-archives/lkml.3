Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaBEXNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:13:01 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:35554 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaBEXNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:13:00 -0500
MIME-Version: 1.0
In-Reply-To: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
Date: Thu, 6 Feb 2014 00:12:59 +0100
Message-ID: <CABPqkBQVdicdgAXob2bHF4hCMTut1LUvbi58a1TVKFT4NDM-=g@mail.gmail.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 10:25 PM, Stephane Eranian <eranian@google.com> wrote:
> Hi,
>
> If you run perf top on 3.14 but you force --stdio mode, perf top
> goes crazy and constantly refreshes the output.
>
> It does that with many older versions of the perf as well on 3.14.
> It runs fine with newt mode.
>
> Works fine with my 3.11 kernel. So something must be broken
> with 3.14.
>
Or more likely, there is something broken in perf which gets exposed
by 3.14.
