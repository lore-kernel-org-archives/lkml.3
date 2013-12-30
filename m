Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab3L3IJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 03:09:54 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54668 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3L3IJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 03:09:53 -0500
MIME-Version: 1.0
In-Reply-To: <a8eee4e15aba50c210ae64aa034bc75b8270b14e.1388416837.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com> <a8eee4e15aba50c210ae64aa034bc75b8270b14e.1388416837.git.yangds.fnst@cn.fujitsu.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 30 Dec 2013 13:39:12 +0530
Message-ID: <CALkWK0ne9xTihj4LOddwLDGcbNHgTjJM3AeMCsCC0uUgAk2scA@mail.gmail.com>
Subject: Re: [PATCH 6/8] perf tools: Make --raw-dump work as a proper option
 for perf list.
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongsheng Yang wrote:
>  tools/perf/builtin-list.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Looks good to me. Thanks for doing this.
