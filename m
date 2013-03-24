Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3CXJta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 05:49:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63171 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3CXJt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 05:49:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC PATCH v2, part4 01/39] vmlinux.lds: add comments for global variables and clean up useless declarations
Date: Sun, 24 Mar 2013 09:47:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com> <1364109934-7851-2-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1364109934-7851-2-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303240947.42085.arnd@arndb.de>
X-Provags-ID: V02:K0:/ypQ11p/GZrz3iBM0IQ5tNUChb92FuFYhr29teOgxHL
 3+Uh4QQo2hUdUC0S2J60aaXVrb4UeAzzCVl5zU9obRQfJthCZU
 QOARFoMAQH3qrblkyJ1U+OpWxceGe6+xmNJJQnkqxZxOwJL1dR
 1T5jXjbRa2Lvd40pZlsXoSH2r5684xy6+VdrcgeGo6Dtya46jA
 hYYtyULMMQ0oZ0iymTsrSCgzcU8C6Y0c3E2CbWs81MAGgINt92
 EKJX1NMNN0kmP1XelwTVsFsoYjIV+2PExP+RPA1AOt2dxOXdBT
 ZTiYR4XQdB2hJ1dhejyGTKwaz0uDBP0VfHs5nys0v79PBcoipz
 7z4fOiTMmRgR0IbL7eQ8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 March 2013, Jiang Liu wrote:
> This patch documents global variables exported from vmlinux.lds.
> 1) Add comments about usage guidelines for global variables exported
>    from vmlinux.lds.S.
> 2) Remove unused __initdata_begin[] and __initdata_end[].
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arch@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/asm-generic/sections.h |   21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)

for asm-generic:

Acked-by: Arnd Bergmann <arnd@arndb.de>
