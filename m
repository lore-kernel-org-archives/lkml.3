Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3KVPYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:24:52 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:54993 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3KVPYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:24:51 -0500
MIME-Version: 1.0
In-Reply-To: <20131122150927.GA10881@krava.brq.redhat.com>
References: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
 <1385044427-13995-3-git-send-email-artagnon@gmail.com> <20131122150927.GA10881@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 22 Nov 2013 20:54:10 +0530
Message-ID: <CALkWK0kyuHRsvWphP4C+U7oLPZCZWFVAwU5vzsN10SHxUcYqjg@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf diff: give Delta column an appropriate color
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> this patch changes the diff output for 'perf diff'
>
> file '1' - old perf
> file '2' - your change
>
> I expected only the difference would be only color
> not numbers.

Oh, sorry; I forgot about the threshold completely. I'll submit
another iteration with a fresh [4/4] once you tell me how to fix that.
