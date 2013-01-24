Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3AXNj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:39:27 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:64583 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab3AXNjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:39:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130124115637.GA523@gmail.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
	<20130124115637.GA523@gmail.com>
Date: Thu, 24 Jan 2013 14:39:16 +0100
Message-ID: <CABPqkBT+9qG8Yj0w37W2YNuy5NirLtgcRg3qnZo7XDkRRwA0tQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/18] perf: add memory access sampling support
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 12:56 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> This patch series had a new feature to the kernel perf_events
>> interface and corresponding user level tool, perf.
>
> Would be nice to merge this with the overlapping parts of Andi's
> Haswell series.
>
That's what I have now. Merged with a couple of patches from Andi's.
Will post update today.
