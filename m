Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab3K1R1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:27:09 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59012 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3K1R1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:27:06 -0500
MIME-Version: 1.0
In-Reply-To: <20131128150847.GF1245@krava.brq.redhat.com>
References: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
 <1385550154-11385-3-git-send-email-artagnon@gmail.com> <20131128150847.GF1245@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 28 Nov 2013 22:56:24 +0530
Message-ID: <CALkWK0nWmvxNd5DE=x-VGZgrrnUni_nbo3sOkyZmFK10OFbnkQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] perf diff: generalize hpp__color_delta for -c
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> This patch basicaly factor the code you added in previous one.
>
> Could we use the function below from the beggining?

Yeah, I suppose I could squash this into [2/4].
