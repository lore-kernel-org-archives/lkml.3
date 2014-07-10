Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaGJXR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 19:17:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaGJXR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 19:17:27 -0400
Message-ID: <53BF1F06.60609@infradead.org>
Date: Thu, 10 Jul 2014 16:17:26 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Cristian Stoica <cristian.stoica@freescale.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Documentation: devres: update list of supported calls
References: <1404720626-20841-1-git-send-email-cristian.stoica@freescale.com>
In-Reply-To: <1404720626-20841-1-git-send-email-cristian.stoica@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 01:10 AM, Cristian Stoica wrote:
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Greg, do you want this patch?

> ---
>  Documentation/driver-model/devres.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> index 1525e30..7a48896 100644
> --- a/Documentation/driver-model/devres.txt
> +++ b/Documentation/driver-model/devres.txt
> @@ -234,6 +234,7 @@ certainly invest a bit more effort into libata core layer).
>    -----------------------------
>  
>  MEM
> +  devm_kmalloc()
>    devm_kzalloc()
>    devm_kfree()
>    devm_kmemdup()
> 


-- 
~Randy
