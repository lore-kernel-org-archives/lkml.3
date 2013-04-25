Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab3DYXwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:52:42 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51051 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab3DYXwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:52:41 -0400
MIME-Version: 1.0
In-Reply-To: <1366887650.31792.26.camel@kjgkr>
References: <1366857842-17240-1-git-send-email-jaegeuk.kim@samsung.com>
	<CAKYAXd-7dkROw0wGQU-9yth90ObRm5b9Vr8aB_zMd4HX2=+ZrQ@mail.gmail.com>
	<1366887650.31792.26.camel@kjgkr>
Date: Fri, 26 Apr 2013 08:52:40 +0900
Message-ID: <CAKYAXd-6J2ZcEjHOcOWpDDnPT-AydLL1N4Ds6t7A9vzLdGKzjw@mail.gmail.com>
Subject: Re: [PATCH v2] f2fs: avoid frequent background GC
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi, Namjae,
>
> Agreed. How about this?
>
> Chang log from v1:
>  o change timings - min 30s, max 60s, nogc 5 min
>  o remove nonreachable routine
>  o consider NOGC_SLEEP_TIME in increate/decrease_sleep_time
>
> From 806e344624414fcf9fc87f6193265859027d51b5 Mon Sep 17 00:00:00 2001
> From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Date: Wed, 24 Apr 2013 13:00:14 +0900
> Subject: [PATCH] f2fs: avoid frequent background GC
> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> linux-f2fs-devel@lists.sourceforge.net
>
> If there is no victim segments selected by background GC, let's wait
> a little bit longer time to collect dirty segments.
> By default, let's give 5 minutes.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks good!
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks~
