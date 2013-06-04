Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3FDJfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:35:24 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38065 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3FDJfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:35:18 -0400
MIME-Version: 1.0
In-Reply-To: <1370337737-30812-4-git-send-email-namhyung@kernel.org>
References: <1370337737-30812-1-git-send-email-namhyung@kernel.org>
	<1370337737-30812-4-git-send-email-namhyung@kernel.org>
Date: Tue, 4 Jun 2013 12:35:16 +0300
X-Google-Sender-Auth: hyV2K65-lDxhaBLdB3fjjhWGa4g
Message-ID: <CAOJsxLH1TjKB7WJH8qmTruZ2sHLA86wOqGWEF+UkSk3c5uOJHQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] perf gtk/hists: Display callchain overhead also
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 12:22 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> Display callchain percent value in the overhead column.
>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
