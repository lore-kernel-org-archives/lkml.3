Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3CJJVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 05:21:44 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55759 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3CJJVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 05:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <1362896833-21104-13-git-send-email-jiang.liu@huawei.com>
References: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
	<1362896833-21104-13-git-send-email-jiang.liu@huawei.com>
Date: Sun, 10 Mar 2013 10:21:42 +0100
X-Google-Sender-Auth: iybRxY2EG2dY6d-TGd5qG9Yvm20
Message-ID: <CAMuHMdWSP-Pb09nAcoMPdEA9mHA=FqjPGAvts9B20q7-iqLckA@mail.gmail.com>
Subject: Re: [PATCH v2, part1 12/29] mm/m68k: use common help functions to
 free reserved pages
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 7:26 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Use common help functions to free reserved pages.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>

24 bytes of text size saved!

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
