Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaF2BbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 21:31:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaF2BbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 21:31:12 -0400
Message-ID: <53AF6C54.4010803@infradead.org>
Date: Sat, 28 Jun 2014 18:31:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>
CC: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Joe Perches <joe@perches.com>,
        linux-doc@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Documentation: devres: Add devm_kmalloc() et al
References: <1403522918-16509-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1403522918-16509-1-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Tejun Heo]

patch OK, Tejun?  You want to apply it?


On 06/23/14 04:28, Daniel Thompson wrote:
> Commit 64c862a83... added new alloc variants to the devres managed
> API. These should be included in the list of managed API found in
> devres.txt.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: linux-doc@vger.kernel.org
> ---
>  Documentation/driver-model/devres.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> index 1525e30..91f5633 100644
> --- a/Documentation/driver-model/devres.txt
> +++ b/Documentation/driver-model/devres.txt
> @@ -234,7 +234,10 @@ certainly invest a bit more effort into libata core layer).
>    -----------------------------
>  
>  MEM
> +  devm_kmalloc()
>    devm_kzalloc()
> +  devm_kmalloc_array()
> +  devm_kcalloc()
>    devm_kfree()
>    devm_kmemdup()
>    devm_get_free_pages()
> 


-- 
~Randy
