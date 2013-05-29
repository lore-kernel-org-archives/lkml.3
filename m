Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965554Ab3E2KX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:23:58 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:58145 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965476Ab3E2KX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:23:57 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBTnKgt0NqzRcAMVMOY8YYtg+3o++8CdQ__dYAuBUmk8Lg@mail.gmail.com>
References: <1369656024-3269-1-git-send-email-eranian@google.com>
	<20130527131256.GD4341@laptop>
	<CABPqkBTnKgt0NqzRcAMVMOY8YYtg+3o++8CdQ__dYAuBUmk8Lg@mail.gmail.com>
Date: Wed, 29 May 2013 12:23:56 +0200
Message-ID: <CABPqkBQjDaUi7ojX_fuazSY52EfCt68b_MKcu+26ONOMmZotBg@mail.gmail.com>
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

On Tue, May 28, 2013 at 10:33 AM, Stephane Eranian <eranian@google.com> wrote:
> On Mon, May 27, 2013 at 3:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>
>> I already queued your v6, however Ingo was ill last week so it didn't
>> get merged. It says nothing changed, so I left whatever I had in my
>> queue.
>>
> Thanks.
>> Please check when it hits tip.
>
> I will check.

Tested this on my NHM system. Seems okay in 3.10-rc3.
