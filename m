Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571Ab3E1Ido (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:33:44 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:64634 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414Ab3E1Idn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:33:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130527131256.GD4341@laptop>
References: <1369656024-3269-1-git-send-email-eranian@google.com>
	<20130527131256.GD4341@laptop>
Date: Tue, 28 May 2013 10:33:42 +0200
Message-ID: <CABPqkBTnKgt0NqzRcAMVMOY8YYtg+3o++8CdQ__dYAuBUmk8Lg@mail.gmail.com>
Subject: Re: [PATCH v7 0/2] perf: use hrtimer for event multiplexing
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 3:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
>
> I already queued your v6, however Ingo was ill last week so it didn't
> get merged. It says nothing changed, so I left whatever I had in my
> queue.
>
Thanks.
> Please check when it hits tip.

I will check.
