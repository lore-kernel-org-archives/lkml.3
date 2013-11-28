Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab3K1RZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:25:08 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48309 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3K1RZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:25:05 -0500
MIME-Version: 1.0
In-Reply-To: <20131128150710.GE1245@krava.brq.redhat.com>
References: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
 <1385550154-11385-2-git-send-email-artagnon@gmail.com> <20131128150710.GE1245@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 28 Nov 2013 22:54:25 +0530
Message-ID: <CALkWK0nr9v5P5sO6UDCMr73i5r+PYaS1Da8vST9aUcHZnqv8JQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] perf diff: color the Delta column
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> these colors are not consistent with colors in baseline,
> moreover all negative values are shown as red
>
> - please check get_percent_color function (used for baseline),
>   it checks the percentage against following values:
>
>   #define MIN_GREEN       0.5
>   #define MIN_RED         5.0

That was intentional. If you want colors that are consistent with the
baseline, what do we do about [4/4], where wdiff numbers can be huge?
(currently I use [green, red] for [positive, negative] there too)
