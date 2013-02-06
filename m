Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab3BFT5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:57:25 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:58604 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab3BFT5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:57:20 -0500
MIME-Version: 1.0
In-Reply-To: <20130206195131.GD29163@infradead.org>
References: <1360161962-9675-1-git-send-email-eranian@google.com>
	<1360161962-9675-3-git-send-email-eranian@google.com>
	<20130206195131.GD29163@infradead.org>
Date: Wed, 6 Feb 2013 20:57:19 +0100
Message-ID: <CABPqkBSz0qGm3ZkzSv=gTRmE2ZDjE9quWzJ63686xic4XgWqLA@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf stat: add per processor socket count aggregation
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 8:51 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Wed, Feb 06, 2013 at 03:46:02PM +0100, Stephane Eranian escreveu:
>>  tools/perf/builtin-stat.c |  126 +++++++++++++++++++++++++++++++++++++++++----
>
> Added the missing 'perf stat' man page entry based on the changeset
> comments,
>
Arg, yes, forgot that. Thanks for fixing it.
