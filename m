Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaIYEcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 00:32:42 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34978 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaIYEcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 00:32:41 -0400
Message-ID: <54239AE0.5070007@hitachi.com>
Date: Thu, 25 Sep 2014 13:32:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Li Bin <huawei.libin@huawei.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, guohanjun@huawei.com,
        wangyijing@huawei.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kprobes: Update Documentation/kprobes.txt
References: <1411612329-32741-1-git-send-email-huawei.libin@huawei.com>
In-Reply-To: <1411612329-32741-1-git-send-email-huawei.libin@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/25 11:32), Li Bin wrote:
> The patch 125e564("Move Kconfig.instrumentation to arch/Kconfig and
> init/Kconfig") had removed the "Instrumentation Support" menu,
> and the configurations under this had be moved to "General setup".
> Update Documentation/kprobes.txt to reflect this change.
> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> ---
>  Documentation/kprobes.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
> index 4bbeca8..ca4a927 100644
> --- a/Documentation/kprobes.txt
> +++ b/Documentation/kprobes.txt
> @@ -304,8 +304,8 @@ architectures:
>  3. Configuring Kprobes
>  
>  When configuring the kernel using make menuconfig/xconfig/oldconfig,
> -ensure that CONFIG_KPROBES is set to "y".  Under "Instrumentation
> -Support", look for "Kprobes".
> +ensure that CONFIG_KPROBES is set to "y". Under "General setup", look
> +for "Kprobes".
>  
>  So that you can load and unload Kprobes-based instrumentation modules,
>  make sure "Loadable module support" (CONFIG_MODULES) and "Module
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


