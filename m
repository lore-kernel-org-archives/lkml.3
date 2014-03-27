Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbaC0VUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 17:20:54 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:38923 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbaC0VUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:20:52 -0400
MIME-Version: 1.0
In-Reply-To: <1395878689-6981-1-git-send-email-artagnon@gmail.com>
References: <1395878689-6981-1-git-send-email-artagnon@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 27 Mar 2014 17:20:12 -0400
Message-ID: <CALkWK0noCnPputbUX29-OxBp+pEnRzZX7YXYqjrJq-7sbadfCQ@mail.gmail.com>
Subject: Re: [PATCH] perf list: Replace --raw-dump with parse_options_subcommand()
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
>  tools/perf/builtin-list.c     | 13 +++++++------
>  tools/perf/perf-completion.sh |  6 +++---
>  2 files changed, 10 insertions(+), 9 deletions(-)

Please ignore this patch. Major thinko on my part.
