Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaHNBEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:04:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45742 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaHNBEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:04:44 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-c1-53ec0b2afd03
Message-id: <53EC0B2A.2070308@samsung.com>
Date: Thu, 14 Aug 2014 10:04:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux@arm.linux.org.uk, santosh.shilimkar@ti.com, will.deacon@arm.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org, damm@opensource.se,
        ard.biesheuvel@linaro.org, olof@lixom.net, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Use 'model' property to set machine_name from Device
 Tree
References: <1404697991-32191-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1404697991-32191-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkUFeL+02wwa4/mhZz1q9hs/j/YTej
	xftlPYwW1788Z7W4//gWk8XZpjfsFpseX2O1uLxrDpvF7cu8Fqeuf2azeN23htlixuSXbBYv
	P55gceD1WDNvDaNHS3MPm8eda3vYPE7M+M3isXlJvceVE02sHit/XGL36NuyitHj+I3tTB6f
	N8kFcEVx2aSk5mSWpRbp2yVwZezbfp2xYD57xeR785kbGD+zdjFyckgImEhsnLGYGcIWk7hw
	bz1bFyMXh5DAUkaJo2t/McMUTexeywKRmM4ocWj/XHYI5zWjRNu7c2wgVbwCWhIn+mYwgdgs
	AqoSq948YQex2YDi+1/cAKsRFQiTWDn9CgtEvaDEj8n3wGwRAQ2JmX+vMIIMZRbYzSSx9v1S
	sAZhgVCJa9e2gBUJCbhK3JvZBzaUU8BN4v6iTWA1zAI6Evtbp0HZ8hKb17xlBhkkITCTQ+Jz
	xyuoiwQkvk0+BDSIAyghK7HpANRrkhIHV9xgmcAoNgvJTbOQjJ2FZOwCRuZVjKKpBckFxUnp
	RYZ6xYm5xaV56XrJ+bmbGIFRfvrfs94djLcPWB9iTAZaOZFZSjQ5H5gk8kriDY3NjCxMTUyN
	jcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcQvbm2VyYZ+9Kx42tMlc
	D3rzTU7xJZfmdsbccGeT5g9yaRWe9r7PT0VtvyNy+dIj7Q1d7xtruA4YbZ9xKXV2319WwcjO
	f4Ud79kuHvBbJLn74/+Xp/avYqv6vuXU8XD+JJGsWTOOOp9r/W718eL9/ekTszrm3zG5Oe1a
	2ysTe2v+l4fcZh6WElNiKc5INNRiLipOBACob4kCCAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jQV0t7jfBBnd2KVrMWb+GzeL/h92M
	Fu+X9TBaXP/ynNXi/uNbTBZnm96wW2x6fI3V4vKuOWwWty/zWpy6/pnN4nXfGmaLGZNfslm8
	/HiCxYHXY828NYweLc09bB53ru1h8zgx4zeLx+Yl9R5XTjSxeqz8cYndo2/LKkaP4ze2M3l8
	3iQXwBXVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZ
	A3S8kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj3/brjAXz2Ssm35vP
	3MD4mbWLkZNDQsBEYmL3WhYIW0ziwr31bF2MXBxCAtMZJQ7tn8sO4bxmlGh7d44NpIpXQEvi
	RN8MJhCbRUBVYtWbJ+wgNhtQfP+LG2A1ogJhEiunX2GBqBeU+DH5HpgtIqAhMfPvFUaQocwC
	u5kk1r5fCtYgLBAqce3aFrAiIQFXiXsz+8CGcgq4SdxftAmshllAR2J/6zQoW15i85q3zBMY
	BWYh2TELSdksJGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSnkGfSOxhXNVgcYhTg
	YFTi4fWIeh0sxJpYVlyZe4hRgoNZSYRXmflNsBBvSmJlVWpRfnxRaU5q8SFGU2AQTGSWEk3O
	B6a3vJJ4Q2MTMyNLI3NDCyNjcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjC6capaGmfN8
	/SSXHtQM3+JXmzTnuWbZ388/jb60mwWzrI4Odny9k3Fu740YF6WTXe7pJju+vP7i+YaNgfvt
	txdXnnyoqwi7u0BDbrJc6PvVMz/4xwSXTV+S+D3N4PmUfybH6hXEbOYx/X45jan9bGEU+46n
	f/+FPo72iXCt/3u6uMzAY3JAiBJLcUaioRZzUXEiAOfcOtE3AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 10:53 AM, Chanwoo Choi wrote:
> This patch use 'model' property from Device Tree to set machine_name.
> The arm64 has already got the machine_name from Device Tree.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  arch/arm/kernel/setup.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 8a16ee5..698616f 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -878,7 +878,11 @@ void __init setup_arch(char **cmdline_p)
>  	if (!mdesc)
>  		mdesc = setup_machine_tags(__atags_pointer, __machine_arch_type);
>  	machine_desc = mdesc;
> +#if CONFIG_OF
> +	machine_name = of_flat_dt_get_machine_name();
> +#else
>  	machine_name = mdesc->name;
> +#endif
>  
>  	if (mdesc->reboot_mode != REBOOT_HARD)
>  		reboot_mode = mdesc->reboot_mode;
> 

Ping.

Best Regards,
Chanwoo Choi
