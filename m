Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3DLUy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:54:58 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:46927 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab3DLUy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:54:56 -0400
Message-ID: <5168749E.80008@tilera.com>
Date: Fri, 12 Apr 2013 16:54:54 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, <linux-mm@kvack.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4, part3 06/41] tile: normalize global variables exported
 by vmlinux.lds
References: <1365258760-30821-1-git-send-email-jiang.liu@huawei.com> <1365258760-30821-7-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1365258760-30821-7-git-send-email-jiang.liu@huawei.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/2013 10:32 AM, Jiang Liu wrote:
> Normalize global variables exported by vmlinux.lds to conform usage
> guidelines from include/asm-generic/sections.h.
>
> 1) Use _text to mark the start of the kernel image including the head
> text, and _stext to mark the start of the .text section.
> 2) Export mandatory global variables __init_begin and __init_end.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Wen Congyang <wency@cn.fujitsu.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/tile/include/asm/sections.h |    2 +-
>  arch/tile/kernel/setup.c         |    4 ++--
>  arch/tile/kernel/vmlinux.lds.S   |    4 +++-
>  arch/tile/mm/init.c              |    2 +-
>  4 files changed, 7 insertions(+), 5 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

