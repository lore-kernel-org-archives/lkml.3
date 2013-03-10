Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3CJKoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:44:21 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:62615 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3CJKoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:44:20 -0400
MIME-Version: 1.0
In-Reply-To: <1362902470-25787-2-git-send-email-jiang.liu@huawei.com>
References: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
	<1362902470-25787-2-git-send-email-jiang.liu@huawei.com>
Date: Sun, 10 Mar 2013 12:44:18 +0200
X-Google-Sender-Auth: YFRXqPptZw-_5P55rVxTb64qndw
Message-ID: <CAOJsxLF7MNrG7Br0LMETrgAraZO=7ELpzyWC-7bXbLKLD8cvow@mail.gmail.com>
Subject: Re: [PATCH v2, part2 01/10] mm: introduce free_highmem_page() helper
 to free highmem pages into buddy system
From: Pekka Enberg <penberg@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 10:01 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Introduce helper function free_highmem_page(), which will be used by
> architectures with HIGHMEM enabled to free highmem pages into the buddy
> system.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
