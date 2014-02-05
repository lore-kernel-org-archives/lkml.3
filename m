Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaBEVZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:25:13 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:35673 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaBEVZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:25:09 -0500
MIME-Version: 1.0
Date: Wed, 5 Feb 2014 22:25:09 +0100
Message-ID: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
Subject: [BUG] perf top: --stdio causes continuous refresh
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If you run perf top on 3.14 but you force --stdio mode, perf top
goes crazy and constantly refreshes the output.

It does that with many older versions of the perf as well on 3.14.
It runs fine with newt mode.

Works fine with my 3.11 kernel. So something must be broken
with 3.14.

Can you reproduce the problem as well?
