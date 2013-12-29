Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab3L2KPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 05:15:21 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36454 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3L2KPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 05:15:19 -0500
MIME-Version: 1.0
In-Reply-To: <20131215123515.GA12431@krava.brq.redhat.com>
References: <1386679742-13357-1-git-send-email-artagnon@gmail.com>
 <1386679742-13357-4-git-send-email-artagnon@gmail.com> <20131215123515.GA12431@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Sun, 29 Dec 2013 15:44:38 +0530
Message-ID: <CALkWK0kXNJfqDcM30GEmZNDEKt5oBp571S1edwayH-GY9mOkKA@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] perf diff: color the Weighted Diff column
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> this one is still wrong, you either need to use 'abs(wdiff) > 0'
> or call value_color_snprintf (which is better) as in previous cases

This was very much intentional on my part (see commit message): I
thought it would be nicer to color it this way because all the numbers
tend to be large. However, I'll resubmit with value_color_snprintf()
now.

p.s- Sorry about the terribly late response; was on vacation.
