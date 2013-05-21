Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3EUHEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:04:09 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:62904 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab3EUHEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:04:07 -0400
MIME-Version: 1.0
In-Reply-To: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
References: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
Date: Tue, 21 May 2013 10:04:05 +0300
X-Google-Sender-Auth: UDKcQzsyHIS6VeA2Ul9Q8Sg22Lw
Message-ID: <CAOJsxLETg8WMrX+gqYA03Bm4tAsgAKVgbH6aay=NS9L-WmKbpQ@mail.gmail.com>
Subject: Re: [RFC 0/7] perf report/gtk: Add support for hierarchy view
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 21, 2013 at 9:14 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> This patchset implements a new feature that collects hist entries in a
> hierachical manner.  That means lower-level entries are belonged to an
> upper-level entry.  The entry hierachy is built on the sort keys
> given, so users can set it whatever they want.  It only shows
> top-level entries first, and user can expand/collapse it dynamically.
>
> This is only implemented in --gtk currently, since it's well-matched
> to the GTK tree view widget and I didn't want to be bothered with the
> TUI browser code at this stage. :)

Can use this infrastructure to support call-graphs in the GTK UI?

                        Pekka
