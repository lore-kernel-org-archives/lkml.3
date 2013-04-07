Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161568Ab3DGIBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 04:01:14 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:38871 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571Ab3DGIBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 04:01:13 -0400
Date: Sun, 7 Apr 2013 10:00:18 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH v4, part3 02/41] avr32: normalize global variables
 exported by vmlinux.lds
Message-ID: <20130407080018.GB31879@samfundet.no>
References: <1365258760-30821-1-git-send-email-jiang.liu@huawei.com>
 <1365258760-30821-3-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365258760-30821-3-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sat 06 Apr 2013 22:32:01 +0800 or thereabout, Jiang Liu wrote:
> Normalize global variables exported by vmlinux.lds to conform usage
> guidelines from include/asm-generic/sections.h.
> 
> Use _text to mark the start of the kernel image including the head text,
> and _stext to mark the start of the .text section.

I'm assuming this series of patches makes this change.

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Cc: linux-kernel@vger.kernel.org

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/kernel/setup.c       |    2 +-
>  arch/avr32/kernel/vmlinux.lds.S |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
